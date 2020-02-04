# frozen_string_literal: true

module CensusRestClient
  class StubbedResponseBuilder
    def self.build_no_data
      []
    end

    def self.build_ex_resident
      [base_attrs.merge("edat" => 0, "barri" => "-")]
    end

    def self.build_resident(params = {})
      age = params[:age] || 35

      [
        base_attrs.merge(
          "habfecnac" => (Time.current - age.years).iso8601,
          "edat" => age,
          "barri" => "ANGELA ROCA-CAN SERRA BALET"
        )
      ]
    end

    def self.build_not_resident_but_pays_taxes
      [base_attrs.merge("edat" => 0, "barri" => "ANGELA ROCA-CAN SERRA BALET")]
    end

    def self.base_attrs
      {
        "habnomhab" => "RODRIGO",
        "habap1hab" => "DÍAZ",
        "habap2hab" => "DE VIVAR",
        "habnomcom" => "DÍAZ DE VIVAR,RODRIGO",
        "sexe" => "D"
      }
    end
  end
end
