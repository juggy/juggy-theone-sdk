# frozen_string_literal: true

require_relative "base"
require_relative "quote"
require_relative "paginator"

module Theone
  # Movie API def
  class Movie < Base
    BASE_PATH = "/movie"

    class << self
      def all(client)
        Paginator.paginate(client, BASE_PATH) { |movie_json| Movie.new(client, movie_json) }
      end

      def one(client, id)
        movie_json = client.api_request("#{BASE_PATH}/#{id}").first
        Movie.new(client, movie_json)
      end
    end

    def quotes
      Paginator.paginate(client, "#{BASE_PATH}/#{id}/quote") { |quote_json| Quote.new(client, quote_json) }
    end
  end
end
