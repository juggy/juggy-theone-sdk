# frozen_string_literal: true

require_relative "base"
require_relative "paginator"

module Theone
  # Quote API def
  class Quote < Base
    BASE_PATH = "/quote"

    class << self
      def all(client)
        Paginator.paginate(client, BASE_PATH) { |quote_json| Quote.new(client, quote_json) }
      end

      def one(client, id)
        quote_json = client.api_request("#{BASE_PATH}/#{id}").first
        Quote.new(client, quote_json)
      end
    end
  end
end
