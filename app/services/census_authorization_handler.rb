# frozen_string_literal: true

# Checks the authorization against the census for Barcelona.
require "digest/md5"

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  attribute :document_number, String
  attribute :date_of_birth, Date

  validates :document_number, format: { with: /\A[A-z0-9+-\\!]*\z/ }, presence: true
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

  def scope
    Decidim::Scope.find(scope_id)
  end

  def census_document_types
    %i(dni nie passport).map do |type|
      [I18n.t(type, scope: "decidim.census_authorization_handler.document_types"), type]
    end
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def document_type_valid
    return nil if response.blank?

    #errors.add(:document_number, I18n.t("census_authorization_handler.invalid_document")) unless response.xpath("//codiRetorn").text == "01"
  end

  def registered_in_town
    return nil if response.blank?
    errors.add(:base, "No empadronat") unless first_person_element.present? && first_person_element.text != ""
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
    errors.add(:base, "Menor de 16 anys") unless first_district_element.present? && first_district_element.text == "-" || first_age_element.present? && first_age_element.text.to_i > 15
  end

  def census_date_of_birth_coincidence
    errors.add(:date_of_birth, I18n.t("census_authorization_handler.invalid_date_of_birth")) unless first_date_of_birth_element && date_of_birth == Date.parse(first_date_of_birth_element.text)
  end

  def response
    return nil if document_number.blank?

    return @response if defined?(@response)

    response ||= maybe_stubbed_response

    @response ||= Nokogiri::XML(response.body).remove_namespaces!
  end

  def maybe_stubbed_response
    if document_number.match(/\+$/)
      OpenStruct.new(body: stubbed_body(date_of_birth))
    elsif document_number.match(/-$/)
      OpenStruct.new(body: stubbed_body(Date.parse("2010-01-01")))
    elsif document_number.match(/!$/)
      OpenStruct.new(body: stubbed_fail_body)
    else
      Faraday.new(:url => Rails.application.secrets.census_url).get do |request|
        request.url("findEmpadronat", dni: document_number)
      end
    end
  end

  def stubbed_body(date)
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><ssagavaVigents><ssagavaVigent><edat>34</edat><habap1hab>SURNAME1</habap1hab><habap2hab>SURNAME2</habap2hab><habfecnac>#{date.to_s}</habfecnac><habnomcom>SURNAME1*SURNAME2,MARY</habnomcom><habnomhab>MARY</habnomhab><haborddir>STREETNAME (L')                         AV     40    0      0         3   4</haborddir><habtoddir>AV STREETNAME (L'),   40 3 4</habtoddir><sexe>D</sexe></ssagavaVigent></ssagavaVigents>"
  end

  def stubbed_fail_body
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><ssagavaVigents></ssagavaVigents>"
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

      if status_code == :ok
        if date_of_birth.blank?
          status_code = :incomplete
          data = { fields: ["date_of_birth"], action: :reauthorize, cancel: true }
        elsif wrong_age
          status_code = :unauthorized
          data[:fields] = { "maximum_age" => maximum_age, "minimum_age" => minimum_age }
        end
      end

      [status_code, data]
    end

    def wrong_age
      return unless maximum_age.to_i <= 0
      return unless minimum_age.to_i <= 0

      maximum_age.to_i.years.ago > date_of_birth || minimum_age.to_i.years.ago < date_of_birth
    end

    def missing_fields
      @missing_fields ||= options.keys.each_with_object([]) do |field, missing|
        missing << field if authorization.metadata&.fetch(field).blank?
        missing
      end
    end
  end
end
