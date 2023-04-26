# frozen_string_literal: true

require_relative "theone/version"
require_relative "theone/client"
require_relative "theone/quote"
require_relative "theone/movie"

module Theone
  # Main SDK entry point
  class Sdk
    attr_reader :client

    def initialize(**options)
      @client = Client.new(**options)
    end

    def movies
      Movie.all(client)
    end

    def movie(id)
      Movie.one(client, id)
    end

    def quotes
      Quote.all(client)
    end

    def quote(id)
      Quote.one(client, id)
    end
  end
end
