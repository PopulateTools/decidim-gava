# frozen_string_literal: true

module CensusRestClient
  class Response
    STUB_SUCCESS_REGEX = /\+$/.freeze
    STUB_SUCCESS_NO_BIRTHDATE_REGEX = /-$/.freeze
    STUB_FAILURE_REGEX = /!$/.freeze

    attr_accessor(
      :document_number,
      :raw_response,
      :age,
      :district
    )

    def self.build_stubbed_response(params = {})
      return [] if params[:failure]

      [
        {
          "habnomhab" => "RODRIGO",
          "habap1hab" => "DÍAZ",
          "habap2hab" => "DE VIVAR",
          "habnomcom" => "DÍAZ DE VIVAR,RODRIGO",
          "edat" => params[:age] || 0,
          "barri" => params[:district] || "-",
          "sexe" => "-"
        }
      ]
    end

    def initialize(params = {})
      self.document_number = params[:document_number].upcase
      make_request
      process_response
    end

    def not_registered_in_census?
      parsed_response.empty?
    end

    def blank_district?
      district.blank?
    end

    def too_young?
      age.present? ? (age < 16) : nil
    end

    # for logging
    def obfuscated_response
      parsed_response.map do |item|
        item.map { |k, v| [k, AttributeObfuscator.secret_attribute_hint(v)] }.to_h
      end
    end

    private

    def make_request
      self.raw_response = HTTParty.get("#{webservice_url}?dni=#{document_number}")
      @parsed_response = raw_response.parsed_response
    end

    def process_response
      return if not_registered_in_census?

      data = parsed_response.first
      self.age = data["edat"]
      self.district = data["barri"] != "-" ? data["barri"] : nil
    end

    def webservice_url
      Rails.application.secrets.census_url
    end

    def parsed_response
      if Rails.env.production?
        @parsed_response
      elsif document_number.match?(STUB_SUCCESS_REGEX)
        self.class.stubbed_response(age: 25, district: "Centre")
      elsif document_number.match?(STUB_SUCCESS_NO_BIRTHDATE_REGEX)
        self.class.stubbed_response(district: "Centre")
      elsif document_number.match?(STUB_FAILURE_REGEX)
        self.class.stubbed_response(failure: true)
      else
        @parsed_response
      end
    end
  end
end
