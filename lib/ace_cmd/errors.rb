# frozen_string_literal: true

module AceCmd
  # Custom error class for fail-fast scenarios in AceCmd
  #
  # @example Raising a FailFastError with a message
  #   raise AceCmd::FailFastError.new("Operation failed")
  #
  # @example Raising a FailFastError with a message and error object
  #   begin
  #     # Some operation that might fail
  #   rescue StandardError => e
  #     raise AceCmd::FailFastError.new("Operation failed", err_obj: e)
  #   end
  class FailFastError < StandardError
    # @return [Object] The associated error object
    attr_reader :err_obj

    # Initialize a new FailFastError
    #
    # @param message [String] The error message
    # @param err_obj [Object] An optional error object associated with this error
    def initialize(message, err_obj: nil)
      super(message)
      @err_obj = err_obj
    end
  end
end
