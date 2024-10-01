# frozen_string_literal: true

# Module for adding callable functionality
module AceCallee
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Class methods for AceCallee
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
