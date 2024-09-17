# frozen_string_literal: true

require "spec_helper"

RSpec.describe AceCmd::Command do
  let(:dummy_class) do
    Class.new do
      include AceCmd::Command

      def call(greeting = nil)
        message = build_greeting(greeting)
        process_message(message.value)
      end

      def build_greeting(greeting)
        greeting ? Success(greeting) : Failure(greeting)
      end

      def process_message(message)
        if message
          Success(message.upcase, meta: { lang: :eng, length: message.length })
        else
          Failure(message, msg: "No message provided")
        end
      end
    end
  end

  let(:message) { "Hello, World!" }

  describe ".call" do
    context "when pipeline success" do
      let(:message) { "Hello, World!" }
      let(:result) { dummy_class.call(message) }

      it "runs the success command" do
        aggregate_failures "result" do
          expect(result.value).to eq(message.upcase)
          expect(result.success).to eq(message.upcase)
        end
      end

      it "returns meta" do
        meta = { lang: :eng, length: message.length }

        expect(result.meta).to eq(meta)
      end
    end

    context "when pipeline failure" do
      let(:result) { dummy_class.call }

      it "runs the failure command" do
        aggregate_failures "result" do
          expect(result).to be_failure
          expect(result.value).to be_nil
        end
      end

      it "returns message" do
        message = "No message provided"

        expect(result.message).to eq(message)
      end
    end
  end
end
