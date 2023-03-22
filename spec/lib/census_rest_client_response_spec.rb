# frozen_string_literal: true

require "rails_helper"

describe CensusRestClient::Response do
  subject(:response) { described_class.new(document_number: document_number) }

  let(:document_number) { "12345678A" }
  let(:httparty_response) { double }
  let(:inner_httparty_response) { double }
  let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_no_data }
  let(:census_url) { Rails.application.secrets.census_url }

  before do
    allow(HTTParty).to(receive(:get).and_return(httparty_response))
    allow(httparty_response).to(receive(:parsed_response).and_return(response_json))
    allow(httparty_response).to(receive(:response).and_return(inner_httparty_response))
    allow(inner_httparty_response).to(receive(:code).and_return(200))
  end

  describe "current_resident?" do
    subject { response.current_resident? }

    context "when no data" do
      it { is_expected.to be false }
    end

    context "when former resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_ex_resident }

      it { is_expected.to be false }
    end

    context "when current resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident }

      it { is_expected.to be true }
    end

    context "when not resident but pays taxes in city" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes }

      it { is_expected.to be false }
    end
  end

  describe "pays_taxes_in_city?" do
    subject { response.pays_taxes_in_city? }

    context "when no data" do
      it { is_expected.to be false }
    end

    context "when former resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_ex_resident }

      it { is_expected.to be false }
    end

    context "when current resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident }

      it { is_expected.to be false }
    end

    context "when not resident but pays taxes in city" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes }

      it { is_expected.to be true }
    end
  end

  describe "age" do
    subject { response.age }

    context "when no data" do
      it { is_expected.to be_nil }
    end

    context "when former resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_ex_resident }

      it { is_expected.to be_nil }
    end

    context "when current resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident(age: 123) }

      it "returns the age" do
        expect(subject).to eq(123)
      end
    end

    context "when not resident but pays taxes in city" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes }

      it { is_expected.to be_nil }
    end
  end

  describe "date_of_birth" do
    subject { response.date_of_birth }

    context "when no data" do
      it { is_expected.to be_nil }
    end

    context "when former resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_ex_resident }

      it { is_expected.to be_nil }
    end

    context "when current resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident(age: 123) }

      it "returns the age" do
        expect(subject).to be_present
      end
    end

    context "when not resident but pays taxes in city" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes }

      it { is_expected.to be_nil }
    end
  end

  describe "obfuscated_response" do
    subject { response.obfuscated_response }

    let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident }

    it "obfuscates personal information" do
      expect(subject).to eq([{
        "barri" => "A*************************T",
        "edat" => "**",
        "habap1hab" => "****",
        "habap2hab" => "D******R",
        "habfecnac"=>"1***********************0",
        "habnomcom" => "D*******************O",
        "habnomhab" => "R*****O",
        "sexe" => "*"
      }])
    end
  end
end
