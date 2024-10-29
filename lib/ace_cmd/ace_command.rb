# frozen_string_literal: true

require "ace_config"

# Module for adding command functionality with success and failure handling
#
# @example Including AceCommand in a class
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
  extend AceConfiguration::Local

  configure :command do
    config :failure
    config :fail_fast
    config :unexpected_err
  end

  # This method is called when the module is included in a class.
  # It extends the base class with class-level methods.
  #
  # @param base [Class] the class that includes this module
  def self.included(base)
    base.extend(AceConfiguration::Local)
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
  # @example Creating a Success instance with metadata
  #   Success("Operation successful", meta: {time: Time.now})
  def Success(value = nil, err: nil, meta: {})
    AceCmd::Success.new(value, err: err, meta: meta)
  end

  # Creates a new Failure instance.
  #
  # @param value [Object] the value to be wrapped in the Failure instance
  # @param err [Exception, nil] an optional exception or error message
  # @param meta [Hash] optional metadata
  # @return [AceCmd::Failure] a new Failure instance
  #
  # @example Creating a Failure instance with an error
  #   Failure("Operation failed", err: StandardError.new("An error occurred"))
  def Failure(value = nil, err: nil, meta: {})
    default_err = self.class.command.failure

    AceCmd::Failure.new(value, err: err || default_err, meta: meta)
  end

  # Creates a new Failure instance and raises a FailFastError.
  #
  # @param value [Object] the value to be wrapped in the Failure instance
  # @param err [Exception, nil] an optional exception or error message
  # @param meta [Hash] optional metadata
  # @return [void]
  # @raise [AceCmd::FailFastError] always raises this error with the created Failure instance
  #
  # @example Triggering a fail-fast scenario
  #   Failure!("Critical error", err: RuntimeError.new("Unexpected condition"))
  def Failure!(value = nil, err: nil, meta: {}, **_opts)
    error = err || self.class.command.fail_fast

    err_obj = AceCmd::Failure.new(value, err: error, meta: meta)

    raise AceCmd::FailFastError.new("Fail Fast Triggered", err_obj: err_obj)
  end
  # rubocop:enable Naming/MethodName
end
