# frozen_string_literal: true

require "digest/md5"

class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  DNI_REGEXP = /\d{8}[a-zA-Z]/.freeze
  NIE_REGEXP = /[a-zA-Z]\d{7}[a-zA-Z]/.freeze
  DOCUMENT_REGEXP_PROD = /\A(#{DNI_REGEXP}|#{NIE_REGEXP})\z/.freeze
  DOCUMENT_REGEXP_TEST = /\A(#{DNI_REGEXP}|#{NIE_REGEXP})(\+|-|!)?\z/.freeze

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
  validate :old_enough
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
    if response.date_of_birth
      super.merge(
        date_of_birth: response.date_of_birth.iso8601
      )
    else
      super
    end
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def registered_in_town
    return if errors.any?

    if !response.current_resident?
      errors.add(:document_number, i18_error_msg(:not_in_census))
    end
  end

  def old_enough
    return if errors.any?

    errors.add(:date_of_birth, i18_error_msg(:not_old_enough)) unless response.age.present? && response.age >= 16
  end

  def census_date_of_birth_coincidence
    return if errors.any?

    if response.age != Utils.age_from_birthdate(date_of_birth)
      errors.add(:date_of_birth, i18_error_msg(:invalid_date_of_birth))
    end
  end

  def response
    @response = begin
      return if errors.any?

      @response = CensusRestClient::Response.new(document_number: document_number)

      log_census_request(@response)

      @response
    end
  end

  def production_env?
    Rails.env.production?
  end

  def log_census_request(response)
    Rails.logger.debug """
      [Census Service][#{user.id}][request] unique_id: #{unique_id} document_filtered: #{AttributeObfuscator.secret_attribute_hint(document_number)}
      birthdate: #{date_of_birth.try(:year)}-**-#{date_of_birth.try(:day)}
    """
    Rails.logger.debug "[Census Service][#{user.id}][response] status: #{response.response_code} body: #{response.obfuscated_response}"
  end

  def i18_error_msg(error_key)
    I18n.t("census_authorization_handler.#{error_key}")
  end

  class ActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
    attr_reader :date_of_birth, :maximum_age, :minimum_age

    # Overrides the parent class method, but it still uses it to keep the base behavior
    def authorize
      authorization_metadata = authorization&.metadata
      raw_date_of_birth = authorization_metadata ? authorization_metadata["date_of_birth"] : nil

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
      @wrong_age_attribute ||= if maximum_age.to_i.positive? && maximum_age.to_i.years.ago > date_of_birth
                                 "maximum_age"
                               elsif minimum_age.to_i.positive? && minimum_age.to_i.years.ago < date_of_birth
                                 "minimum_age"
                               end
    end

    def has_age_options?
      minimum_age.to_i.positive? || maximum_age.to_i.positive?
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
