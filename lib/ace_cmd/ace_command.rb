# frozen_string_literal: true

require "ace_config"

# @example Including AceCmd in a class
#   class MyCommand
#     include AceCommand
#
#     def call(arg)
#       Success(arg)
#     end
#   end
#
#   result = MyCommand.call("Hello")
#   puts result.value # => "Hello"
module AceCommand
  include AceConfiguration::Isolated

  configure :command do
    config :failure
    config :fail_fast
    config unexpected_err: true
  end

  # This method is called when the module is included in a class.
  # It extends the base class with class-level methods.
  #
  # @param base [Class] the class that includes this module
  def self.included(base)
    base.include(AceConfiguration::Isolated)
    base.include(AceCallee)
    base.extend(AceCmd::Command)

    base.configure :command, hash: command.to_h, schema: command.type_schema
  end

  # rubocop:disable Naming/MethodName
  # Creates a new Success instance.
  #
  # @param value [Object] the value to be wrapped in the Success instance
  # @param err [Exception, nil] an optional exception
  # @param meta [Hash] optional metadata
  # @return [AceCmd::Success] a new Success instance
  #
  # @example
  #   Success("Operation successful", meta: {time: Time.now})
  def Success(value = nil, err: nil, meta: {})
    AceCmd::Success.new(value, err: err, meta: meta)
  end

  # Creates a new Failure instance.
  #
  # @param value [Object] the value to be wrapped in the Failure instance
  # @param err [Exception, nil] an optional exception
  # @param meta [Hash] optional metadata
  # @return [AceCmd::Failure] a new Failure instance
  #
  # @example
  #   Failure("Operation failed", err: StandardError.new("An error occurred"))
  def Failure(value = nil, err: nil, meta: {})
    default_err = self.class.command.failure

    AceCmd::Failure.new(value, err: err || default_err, meta: meta)
  end

  # Creates a new Failure instance and raises an error.
  #
  # @param value [Object] the value to be wrapped in the Failure instance
  # @param err [Exception, nil] an optional exception
  # @param meta [Hash] optional metadata
  # @return [void]
  # @raise [FailFastError] always raises this error
  #
  # @example
  #   Failure!("Critical error", err: RuntimeError.new("Unexpected condition"))
  def Failure!(value = nil, err: nil, meta: {}, **_opts)
    error = err || self.class.command.fail_fast

    err_obj = AceCmd::Failure.new(value, err: error, meta: meta)

    raise AceCmd::FailFastError.new("Fail Fast Triggered", err_obj: err_obj)
  end
  # rubocop:enable Naming/MethodName
end
