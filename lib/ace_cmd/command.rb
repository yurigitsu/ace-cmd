# frozen_string_literal: true

module AceCmd
  # This class handles command execution.
  module Command
    # This method is called when the module is included in a class.
    # It extends the base class with class-level methods.
    #
    # @param base [Class] the class that includes this module
    #
    # @example
    #   class MyCommand
    #     include AceCmd::Command
    #   end
    #
    #   MyCommand.included(base) # => extends MyCommand with class methods
    def self.included(base)
      base.extend(ClassMethods)
    end

    # This module provides class-level methods for command execution.
    module ClassMethods
      # Calls the instance method `call` on a new instance of the class.
      #
      # @param ... [*] arguments to be passed to the instance method
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
      #   MyCommand.call("Hello") # => Success instance with value "Hello"
      def call(...)
        new.call(...)
      end
    end

    # rubocop:disable Naming/MethodName
    # Creates a new Success instance.
    #
    # @param value [Object] the value to be wrapped in the Success instance
    # @param msg [String, nil] an optional message
    # @param meta [Hash] optional metadata
    # @return [AceCmd::Success] a new Success instance
    #
    # @example
    #   Success("Operation successful") # => Success instance with value "Operation successful"
    def Success(value = nil, msg: nil, meta: {})
      AceCmd::Success.new(value, msg: msg, meta: meta)
    end

    # Creates a new Failure instance.
    #
    # @param value [Object] the value to be wrapped in the Failure instance
    # @param msg [String, nil] an optional message
    # @param meta [Hash] optional metadata
    # @return [AceCmd::Failure] a new Failure instance
    #
    # @example
    #   Failure("Operation failed", msg: "An error occurred") # => Failure instance with value "Operation failed"
    def Failure(value = nil, msg: nil, meta: {})
      AceCmd::Failure.new(value, msg: msg, meta: meta)
    end
    # rubocop:enable Naming/MethodName
  end
end
