# frozen_string_literal: true

require "digest/md5"

class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  DNI_REGEXP = /\d{8}[a-zA-Z]/
  NIE_REGEXP = /[a-zA-Z]\d{7}[a-zA-Z]/
  DOCUMENT_REGEXP_PROD = /\A(#{DNI_REGEXP}|#{NIE_REGEXP})\z/
  DOCUMENT_REGEXP_TEST = /\A(#{DNI_REGEXP}|#{NIE_REGEXP})(\+|-|!)?\z/

  attribute :document_number, String
  attribute :date_of_birth, Date

  validates(
    :document_number,
    format: { with: DOCUMENT_REGEXP_TEST },
    presence: true,
    unless: :production_env?
  )
  validates(
    :document_number,
    format: { with: DOCUMENT_REGEXP_PROD },
    presence: true,
    if: :production_env?
  )
  validates :date_of_birth, presence: true
  validate :registered_in_town
  validate :district_is_blank_or_over_16
  validate :census_date_of_birth_coincidence

  def self.from_params(params, additional_params = {})
    instance = super(params, additional_params)

    params_hash = hash_from(params)

    if params_hash["date_of_birth(1i)"]
      date = Date.civil(
        params["date_of_birth(1i)"].to_i,
        params["date_of_birth(2i)"].to_i,
        params["date_of_birth(3i)"].to_i
      )

      instance.date_of_birth = date
    end

    instance
  end

  # If you need to store any of the defined attributes in the authorization you
  # can do it here.
  #
  # You must return a Hash that will be serialized to the authorization when
  # it's created, and available though authorization.metadata
  def metadata
    super.merge(date_of_birth: Date.parse(first_date_of_birth_element.text).to_s)
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def registered_in_town
    return nil if response.blank?
    errors.add(:document_number, i18_error_msg(:not_in_census)) unless first_person_element.present? && first_person_element.text != ""
  end

  def first_person_element
    response.xpath("//ssagavaVigents").first
  end

  def first_district_element
    response.xpath("//ssagavaVigents//ssagavaVigent//barri").first
  end

  def first_age_element
    response.xpath("//ssagavaVigents//ssagavaVigent//edat").first
  end

  def first_date_of_birth_element
    response.xpath("//ssagavaVigents//ssagavaVigent//habfecnac").first
  end

  def district_is_blank_or_over_16
    return nil if response.blank?
    return nil if errors.any? # Don't need to check anything if there are errors already

    unless first_district_element.present? && first_district_element.text == "-" || first_age_element.present? && first_age_element.text.to_i > 15
      errors.add(:date_of_birth, i18_error_msg(:not_old_enough))
    end
  end

  def census_date_of_birth_coincidence
    return if (errors.keys - [:date_of_birth]).any? # Don't add more errors if user is not in census

    unless first_person_element&.text&.blank? || first_date_of_birth_element && date_of_birth == Date.parse(first_date_of_birth_element.text)
      errors.add(:date_of_birth, i18_error_msg(:invalid_date_of_birth))
    end
  end

  def response
    return nil if document_number.blank?

    return @response if defined?(@response)

    response ||= maybe_stubbed_response

    log_census_request(response)

    @response ||= Nokogiri::XML(response.body).remove_namespaces!
  end

  def maybe_stubbed_response
    if document_number.match(/\+$/) && !production_env?
      OpenStruct.new(body: stubbed_body(date_of_birth))
    elsif document_number.match(/-$/) && !production_env?
      OpenStruct.new(body: stubbed_body(Date.parse("2010-01-01")))
    elsif document_number.match(/!$/) && !production_env?
      OpenStruct.new(body: stubbed_fail_body)
    else
      Faraday.new(:url => Rails.application.secrets.census_url).get do |request|
        request.url("findEmpadronat", dni: document_number.upcase)
      end
    end
  end

  def stubbed_body(date)
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><ssagavaVigents><ssagavaVigent><edat>34</edat><habap1hab>SURNAME1</habap1hab><habap2hab>SURNAME2</habap2hab><habfecnac>#{date.to_s}</habfecnac><habnomcom>SURNAME1*SURNAME2,MARY</habnomcom><habnomhab>MARY</habnomhab><haborddir>STREETNAME (L')                         AV     40    0      0         3   4</haborddir><habtoddir>AV STREETNAME (L'),   40 3 4</habtoddir><sexe>D</sexe></ssagavaVigent></ssagavaVigents>"
  end

  def stubbed_fail_body
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><ssagavaVigents></ssagavaVigents>"
  end

  def production_env?
    Rails.env.production?
  end

  def log_census_request(response)
    compact_document = document_number.gsub(/\s+/, "").upcase

    Rails.logger.debug "[Census Service][#{user.id}][request] unique_id: #{unique_id} document_filtered: #{compact_document.gsub(/(?!^).(?!$)(?!.{3,4}$)/,"*")} birthdate: #{date_of_birth}"
    Rails.logger.debug "[Census Service][#{user.id}][response] status: #{response.status} body: #{response.body}"
  end

  def i18_error_msg(error_key)
    I18n.t("census_authorization_handler.#{error_key}")
  end

  class ActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
    attr_reader :date_of_birth, :maximum_age, :minimum_age

    # Overrides the parent class method, but it still uses it to keep the base behavior
    def authorize
      raw_date_of_birth = authorization&.metadata&.fetch("date_of_birth")
      @maximum_age ||= options.delete("maximum_age")
      @minimum_age ||= options.delete("minimum_age")
      @date_of_birth ||= raw_date_of_birth ? Date.parse(raw_date_of_birth) : nil

      status_code, data = *super

      if has_age_options? && status_code == :ok
        if date_of_birth.blank?
          status_code = :incomplete
          data = { fields: ["date_of_birth"], action: :reauthorize, cancel: true }
        elsif wrong_age_attribute.present?
          status_code = :unauthorized
          data[:extra_explanation] = { key: wrong_age_attribute,
                                       params: { scope: "decidim.authorization_handlers.census_authorization_handler.unauthorized",
                                                 value: send(wrong_age_attribute) } }
        end
      end

      log_authorization_result(status_code, data)

      [status_code, data]
    end

    def wrong_age_attribute
      @wrong_age_attribute ||= if maximum_age.to_i > 0 && maximum_age.to_i.years.ago > date_of_birth
                                 "maximum_age"
                               elsif minimum_age.to_i > 0 && minimum_age.to_i.years.ago < date_of_birth
                                 "minimum_age"
                               end
    end

    def has_age_options?
      minimum_age.to_i > 0 || maximum_age.to_i > 0
    end

    def missing_fields
      @missing_fields ||= options.keys.each_with_object([]) do |field, missing|
        missing << field if authorization.metadata&.fetch(field).blank?
        missing
      end
    end

    def log_authorization_result(status_code, data)
      Rails.logger.debug "==========="
      Rails.logger.debug "code: #{status_code}"
      Rails.logger.debug "data: #{data.pretty_inspect}"
      Rails.logger.debug "Date of birth: #{date_of_birth}"
      Rails.logger.debug "Minimum age setting: #{minimum_age}"
      Rails.logger.debug "Maximum age setting: #{maximum_age}"
      Rails.logger.debug "Authorization: #{authorization.pretty_inspect}"
      Rails.logger.debug "==========="
    end
  end
end
