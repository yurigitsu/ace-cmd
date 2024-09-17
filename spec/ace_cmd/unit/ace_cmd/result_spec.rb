# frozen_string_literal: true

require "rspec"

RSpec.describe AceCmd::Result do
  let(:value) { "test_value" }

  describe "#initialize" do
    it { expect(described_class.new(value).value).to eq(value) }
  end

  describe "#result" do
    it "returns result object" do
      result = described_class.new(value)

      expect(result.result).to eq(result)
    end
  end

  describe "#message" do
    it "returns message" do
      result = described_class.new(value, msg: "test_message")

      expect(result.message).to eq("test_message")
    end
  end

  describe "#meta" do
    it "returns meta" do
      result = described_class.new(value, meta: { "test_meta" => "test_value" })

      expect(result.meta).to eq({ "test_meta" => "test_value" })
    end
  end
end
