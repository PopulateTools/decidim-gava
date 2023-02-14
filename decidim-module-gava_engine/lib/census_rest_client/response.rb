# frozen_string_literal: true

module CensusRestClient
  class Response
    STUB_SUCCESS_REGEX = /\+$/.freeze
    STUB_SUCCESS_NO_BIRTHDATE_REGEX = /-$/.freeze
    STUB_FAILURE_REGEX = /!$/.freeze

    attr_accessor(
      :document_number,
      :response_code,
      :age,
      :date_of_birth
    )

    def initialize(params = {})
      self.document_number = params[:document_number].upcase
      make_request
      process_response
    end

    def current_resident?
      age.present? && age.positive?
    end

    # for logging
    def obfuscated_response
      return parsed_response unless parsed_response.is_a?(Array)

      parsed_response.map do |item|
        item.map { |k, v| [k, AttributeObfuscator.secret_attribute_hint(v)] }.to_h
      end
    end

    private

    def make_request
      raw_response = HTTParty.get("#{webservice_url}?dni=#{document_number}")
      self.response_code = raw_response.response.code
      @parsed_response = raw_response.parsed_response
    end

    def process_response
      return if parsed_response.empty?

      data = parsed_response.first
      self.age = (data["edat"] == "-" || data["edat"].to_i.zero?) ? nil : data["edat"].to_i
      self.date_of_birth = data["habfecnac"].present? ? Time.zone.parse(data["habfecnac"]) : nil
    end

    def webservice_url
      Rails.application.secrets.census_url
    end

    def parsed_response
      if Rails.env.production?
        @parsed_response
      elsif document_number.match?(STUB_SUCCESS_REGEX)
        CensusRestClient::StubbedResponseBuilder.build_resident
      elsif document_number.match?(STUB_SUCCESS_NO_BIRTHDATE_REGEX)
        CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes
      elsif document_number.match?(STUB_FAILURE_REGEX)
        CensusRestClient::StubbedResponseBuilder.build_ex_resident
      else
        @parsed_response
      end
    end
  end
end
