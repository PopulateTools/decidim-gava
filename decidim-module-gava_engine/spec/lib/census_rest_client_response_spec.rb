# frozen_string_literal: true

require "rails_helper"

describe CensusRestClient::Response do
  subject(:response) { described_class.new(document_number: document_number) }

  let(:document_number) { "12345678A" }
  let(:httparty_response) { double }
  let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response }
  let(:census_url) { Rails.application.secrets.census_url }

  before do
    allow(HTTParty).to(receive(:get).and_return(httparty_response))
    allow(httparty_response).to(receive(:parsed_response).and_return(stubbed_response))
  end

  describe "not_registered_in_census?" do
    subject { response.not_registered_in_census? }

    context "when user is in census" do
      it { is_expected.to be false }
    end

    context "when user is not in census" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(failure: true) }

      it { is_expected.to be true }
    end
  end

  describe "blank_district?" do
    subject { response.blank_district? }

    context "when user is in census and has a district" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(district: "Center") }

      it { is_expected.to be false }
    end

    context "when user is in census and district is blank" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(district: "-") }

      it { is_expected.to be true }
    end

    context "when user is not in census" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(failure: true) }

      it { is_expected.to be true }
    end
  end

  describe "too_young?" do
    subject { response.too_young? }

    context "when user is in census and is under 16" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(age: 10) }

      it { is_expected.to be true }
    end

    context "when user is in census and is over 16" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(age: 20) }

      it { is_expected.to be false }
    end

    context "when user is not in census" do
      let(:stubbed_response) { CensusRestClient::Response.build_stubbed_response(failure: true) }

      it { is_expected.to be_nil }
    end
  end

  describe "obfuscated_response" do
    subject { response.obfuscated_response }

    it "obfuscates personal information" do
      expect(subject).to eq([{
        "barri" => "*",
        "edat" => "*",
        "habap1hab" => "****",
        "habap2hab" => "D******R",
        "habnomcom" => "D*******************O",
        "habnomhab" => "R*****O",
        "sexe" => "*"
      }])
    end
  end
end
