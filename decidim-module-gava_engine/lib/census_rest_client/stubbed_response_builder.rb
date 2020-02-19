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
      if params[:age]
        age = params[:age]
        date_of_birth = (Time.current - age.years)
      elsif params[:date_of_birth]
        age = Utils.age_from_birthdate(params[:date_of_birth])
        date_of_birth = params[:date_of_birth]
      else
        age = 35
        date_of_birth = 35.years.ago
      end

      [
        base_attrs.merge(
          "habfecnac" => date_of_birth.iso8601,
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
