# frozen_string_literal: true

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
      e.err_obj
    rescue StandardError => e
      internal_err = command.unexpected_err
      raise e unless internal_err

      Failure.new(e, err: internal_err.is_a?(TrueClass) ? e : internal_err)
    end

    # Calls the instance method `call!` on a new instance of the class.
    #
    # @param args [Array] arguments to be passed to the instance method
    # @return [Object] the raw result of the instance method call
    # @raise [StandardError] if any error occurs during execution
    # @example
    #   class MyCommand
    #     include AceCommand
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
end
