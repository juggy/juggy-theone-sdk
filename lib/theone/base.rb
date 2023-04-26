# frozen_string_literal: true

module Theone
  # Base class to provide access to the json data
  class Base
    attr_reader :attributes, :client

    def initialize(client, json)
      @client = client
      @attributes = json
    end

    def method_missing(att, *_args, &_block)
      return attributes["_id"] if att == :id

      attributes.key?(att.to_s) ? attributes[att.to_s] : super
    end

    def respond_to_missing?(att, _)
      att = :_id if att == :id
      attributes.key?(att.to_s) || super
    end
  end
end
