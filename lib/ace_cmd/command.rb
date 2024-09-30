# frozen_string_literal: true

require "ace_config"

# Provides command interface functionality for AceCmd
#
# @example Including AceCmd in a class
#   class MyCommand
#     include AceCmd
#
#     def call(arg)
#       Success(arg)
#     end
#   end
#
#   result = MyCommand.call("Hello")
#   puts result.value # => "Hello"
module AceCmd
  include AceConfig::Isolated

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
    base.include(AceConfig::Isolated)
    base.include(Callee)
    base.extend(ClassMethods)

    base.configure :command, hash: command.to_h, schema: command.type_schema
  end

  # Module for adding callable functionality
  module Callee
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class methods for Callee
    module ClassMethods
      # Calls the instance method `call` on a new instance of the class.
      #
      # @param args [Array] arguments to be passed to the instance method
      # @return [Object] the result of the instance method call
      def call(...)
        new.call(...)
      end
    end
  end

  # This module provides class-level methods for command execution.
  module ClassMethods
    # Calls the instance method `call` on a new instance of the class.
    #
    # @param args [Array] arguments to be passed to the instance method
    # @return [Object] the result of the instance method call
    # @example
    #   class MyCommand
    #     include AceCmd::Command
    #
    #     def call(arg)
    #       Success(arg)
    #     end
    #   end
    #
    #   result = MyCommand.call("Hello")
    #   puts result.value # => "Hello"
    def call(...)
      super
    rescue FailFastError => e
      e.err_obj
    rescue StandardError => e
      internal_err = command.unexpected_err
      raise e unless internal_err

      Failure.new(e, err: internal_err.is_a?(TrueClass) ? e : internal_err)
    end

    # Calls the instance method `call!` on a new instance of the class.
    #
    # @param args [Array] arguments to be passed to the instance method
    # @return [Object] the result of the instance method call
    # @example
    #   class MyCommand
    #     include AceCmd
    #
    #     def call!(arg)
    #       arg.upcase
    #     end
    #   end
    #
    #   result = MyCommand.call!("hello")
    #   puts result # => "HELLO"
    def call!(...)
      new.call!(...)
    end
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
    Success.new(value, err: err, meta: meta)
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

    Failure.new(value, err: err || default_err, meta: meta)
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

    err_obj = Failure(value, err: error, meta: meta)

    raise FailFastError.new("Fail Fast Triggered", err_obj: err_obj)
  end
  # rubocop:enable Naming/MethodName
end
