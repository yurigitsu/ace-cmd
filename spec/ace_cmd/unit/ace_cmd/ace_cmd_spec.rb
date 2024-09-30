# frozen_string_literal: true

require "spec_helper"

RSpec.describe AceCmd do
  let(:dummy_class) { Class.new { include AceCmd } }

  describe "#Success" do
    it "returns a Success instance" do
      expect(dummy_class.new.Success).to be_a(AceCmd::Success)
    end

    describe "#Failure" do
      it "returns a Failure instance" do
        expect(dummy_class.new.Failure).to be_a(AceCmd::Failure)
      end
    end
  end
end
