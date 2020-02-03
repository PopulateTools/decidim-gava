# frozen_string_literal: true

require "rails_helper"

describe AttributeObfuscator do
  let(:obfuscator) { AttributeObfuscator }

  describe "#name_hint" do
    subject { obfuscator.name_hint(name) }

    context "with blank names" do
      let(:name) { "" }

      it { is_expected.to be_nil }
    end

    context "with very short names" do
      let(:name) { "Al" }

      it { is_expected.to eq("**") }
    end

    context "with short names" do
      let(:name) { "Ann" }

      it { is_expected.to eq("A*n") }
    end

    context "with regular names" do
      let(:name) { "Harry Potter" }

      it { is_expected.to eq("Har******ter") }
    end
  end

  describe "#secret_attribute_hint" do
    subject { obfuscator.secret_attribute_hint(attribute_value) }

    context "with blank attributes" do
      let(:attribute_value) { "" }

      it { is_expected.to be_nil }
    end

    context "with short attributes" do
      let(:attribute_value) { "abc" }

      it { is_expected.to eq("***") }
    end

    context "with long attributes" do
      let(:attribute_value) { "12345678X" }

      it { is_expected.to eq("1*******X") }
    end
  end
end
