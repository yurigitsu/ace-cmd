# frozen_string_literal: true

require "spec_helper"

RSpec.describe AceCmd do
  before do
    stub_const("DummyCallee", Class.new do
      include AceCallee
      def call(rez)
        rez
      end
    end)

    stub_const(
      "BaseDummyCommand", Class.new do
        include AceCommand

        command do
          fail_fast "Yo"
        end
      end
    )

    stub_const("DummyFailFastError", Class.new(StandardError))
    stub_const("DummyInternalError", Class.new(StandardError))

    stub_const(
      "DummyCommand",
      Class.new(BaseDummyCommand) do
        command do
          fail_fast "Default Fail Fselfast message provided"
          unexpected_err DummyInternalError
        end
      end
    )

    stub_const(
      "MyDummyCommand",
      Class.new(DummyCommand) do
        command do
          fail_fast DummyFailFastError
        end

        def call(greeting = nil)
          salute = build_greeting(greeting)
          howdy = normalize_salute(salute, fail_fast)

          process_howdy(howdy)
        end

        def build_greeting(greeting)
          greeting
        end

        def normalize_salute(salute, fail_fast)
          fail_fast ? Failure!(err: "No message provided") : salute
        end

        def process_howdy(howdy)
          if howdy
            Success(howdy.upcase, meta: { lang: :eng, length: howdy.length })
          else
            Failure(howdy, err: "No message provided")
          end
        end

        def call(greeting = nil, fail_fast: false, unexpected_err: false)
          raise "Oooooooops" if unexpected_err

          salute = build_greeting(greeting)
          howdy = normalize_salute(salute, fail_fast)

          process_howdy(howdy.value)
        end

        def build_greeting(greeting)
          greeting ? Success(greeting) : Failure(greeting)
        end

        def normalize_salute(salute, fail_fast)
          return Success("#{salute.success}!") if salute.success?

          fail_fast ? Failure!(salute) : salute
        end

        def process_howdy(howdy)
          if howdy
            Success(howdy.upcase, meta: { lang: :eng, length: howdy.length })
          else
            Failure(howdy, err: "No message provided")
          end
        end
      end
    )
  end

  let(:message) { "Hello, World" }

  describe ".call" do
    context "when pipeline success" do
      let(:raw_message) { "Hello, World" }
      let(:message) { "Hello, World!" }
      let(:result) { MyDummyCommand.call(raw_message) }

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
      let(:result) { MyDummyCommand.call }

      it "runs the failure command" do
        aggregate_failures "result" do
          expect(result).to be_failure
          expect(result.value).to be_nil
        end
      end

      it "returns message" do
        message = "No message provided"

        expect(result.error).to eq(message)
      end
    end

    context "when fail-fast" do
      let(:result) { MyDummyCommand.call(fail_fast: true) }

      it "returns failure" do
        expect(result.error).to eq(DummyFailFastError)
      end
    end

    context "when unexpected error" do
      let(:result) { MyDummyCommand.call(unexpected_err: true) }

      it "returns failure" do
        expect(result.error).to eq(DummyInternalError)
      end
    end

    context "when simple command" do
      let(:result) { DummyCallee.call("Success!") }

      it "returns success" do
        expect(result).to eq("Success!")
      end
    end
  end
end
