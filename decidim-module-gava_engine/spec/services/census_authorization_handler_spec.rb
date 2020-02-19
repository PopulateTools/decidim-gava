# frozen_string_literal: true

require "rails_helper"
require "decidim/dev/test/authorization_shared_examples"

describe CensusAuthorizationHandler do
  let(:registered_dni) { "12345678a" }
  let(:registered_nie) { "x1234567a" }
  let(:invalid_dni) { "(╯°□°）╯︵ ┻━┻" }
  let(:document_number) { registered_dni }

  let(:date_of_birth) { Time.zone.parse("1987-09-17") }

  let(:user) { create(:user, nickname: "nickname") }
  let(:subject) { handler }
  let(:handler) { described_class.from_params(params) }
  let(:handler_errors) { handler.valid?; handler.errors }
  let(:params) do
    {
      document_number: document_number,
      date_of_birth: date_of_birth,
      user: user
    }
  end

  let(:httparty_response) { double }
  let(:inner_httparty_response) { double }
  let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_no_data }

  before do
    allow(HTTParty).to(receive(:get).and_return(httparty_response))
    allow(httparty_response).to(receive(:parsed_response).and_return(response_json))
    allow(httparty_response).to(receive(:response).and_return(inner_httparty_response))
    allow(inner_httparty_response).to(receive(:code).and_return(200))
  end

  it_behaves_like "an authorization handler"

  context "with invalid response" do
    let(:response_json) { "SOME ERROR!" }

    it "is not valid" do
      expect(handler).not_to be_valid
      expect(handler_errors[:document_number]).to eq(["No empadronat"])
    end
  end

  context "when user is registered in census" do
    context "when it's under the minimum age" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident(age: 10) }

      it "is not valid" do
        expect(handler).not_to be_valid
        expect(handler_errors[:date_of_birth]).to eq(["Menor de 16 anys"])
      end
    end

    context "when it's someone who pays taxes in city" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes }

      it { is_expected.to be_valid }
    end

    context "when it's a former resident" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_ex_resident }

      it { is_expected.not_to be_valid }
    end

    context "when everyghint is OK" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident(date_of_birth: date_of_birth) }

      it { is_expected.to be_valid }
    end
  end

  context "when user is not registered in cesus" do
    let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_no_data }

    it "is not valid" do
      expect(handler).not_to be_valid
      expect(handler_errors[:document_number]).to eq(["No empadronat"])
    end
  end

  describe "document_number" do
    context "when it isn't present" do
      let(:document_number) { nil }

      it "is not valid" do
        expect(handler).not_to be_valid
        expect(handler_errors[:document_number]).to eq(["is invalid", "can't be blank"])
      end
    end

    context "with an invalid format" do
      let(:document_number) { invalid_dni }

      it "is not valid" do
        expect(handler).not_to be_valid
        expect(handler_errors[:document_number]).to eq(["is invalid"])
      end
    end
  end

  describe "date_of_birth" do
    context "when it isn't present" do
      let(:date_of_birth) { nil }

      it "is not valid" do
        expect(handler).not_to be_valid
      end
    end

    context "when data from a date field is provided" do
      let(:params) do
        {
          "date_of_birth(1i)" => "2010",
          "date_of_birth(2i)" => "8",
          "date_of_birth(3i)" => "16"
        }
      end

      it "correctly parses the date" do
        expect(subject.date_of_birth.year).to eq(2010)
        expect(subject.date_of_birth.month).to eq(8)
        expect(subject.date_of_birth.day).to eq(16)
      end
    end
  end

  describe "unique_id" do
    it "generates a different ID for a different document number" do
      handler.document_number = registered_dni
      unique_id1 = handler.unique_id

      handler.document_number = registered_nie
      unique_id2 = handler.unique_id

      expect(unique_id1).not_to eq(unique_id2)
    end

    it "generates the same ID for the same document number" do
      handler.document_number = registered_dni
      unique_id1 = handler.unique_id

      handler.document_number = registered_dni
      unique_id2 = handler.unique_id

      expect(unique_id1).to eq(unique_id2)
    end

    it "hashes the document number" do
      handler.document_number = registered_dni
      unique_id = handler.unique_id

      expect(unique_id).not_to include(handler.document_number)
    end
  end

  describe "metadata" do
    context "when date_of_birth is required" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_resident(date_of_birth: date_of_birth) }

      it "includes the date of birth" do
        expect(subject.metadata).to include(date_of_birth: date_of_birth.iso8601)
      end
    end

    context "when date_of_birth is not required" do
      let(:response_json) { CensusRestClient::StubbedResponseBuilder.build_not_resident_but_pays_taxes }

      it "is empty" do
        expect(subject.metadata).to eq({})
      end
    end
  end
end
