# frozen_string_literal: true

# [TODO:] add error trace

# Provides command interface functionality for AceCmd
module AceCmd
  # This module provides class-level methods for command execution.
  module Command
    # Calls the instance method `call` on a new instance of the class.
    #
    # @param args [Array] arguments to be passed to the instance method
    # @return [AceCmd::Success, AceCmd::Failure] the result of the instance method call
    # @raise [StandardError] if unexpected_err is not set and a StandardError occurs
    # @example
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
    def call(...)
      super
    rescue FailFastError => e
      e.err_obj.tap { |err| err.trace = e.backtrace.first }
    rescue StandardError => e
      internal_err = command.unexpected_err
      raise e unless internal_err

      err = internal_err.is_a?(TrueClass) ? e : internal_err

      Failure.new(e, err: err, trace: e.backtrace.first)
    end
  end
end
