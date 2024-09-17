# frozen_string_literal: true

module AceCmd
  # This class represents a result.
  #
  # @example
  #   result = AceCmd::Result.new("Success", msg: "Operation completed", meta: { key: "value" })
  #   result.value # => "Success"
  #   result.message # => "Operation completed"
  #   result.meta # => { key: "value" }
  #
  # @!attribute [r] value
  #   @return [Object] the value associated with the result
  #
  # @!attribute [r] msg
  #   @return [String, nil] an optional message associated with the result
  #
  # @!attribute [r] meta
  #   @return [Hash] optional metadata associated with the result
  class Result
    attr_reader :value, :msg, :meta

    # Initializes a new Result instance.
    #
    # @param value [Object] the value to be wrapped in the result
    # @param msg [String, nil] an optional message
    # @param meta [Hash] optional metadata
    def initialize(value, msg: nil, meta: {})
      @value = value
      @msg = msg
      @meta = meta
    end

    # Returns the result instance itself.
    #
    # @return [AceCmd::Result] the result instance
    def result
      self
    end

    # Returns the message associated with the result.
    #
    # @return [String, nil] the message
    def message
      msg
    end
  end
end
