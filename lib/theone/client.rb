# frozen_string_literal: true

require "net/http"
require "json"

module Theone
  # HTTP client to connect to the One API
  class Client
    DEFAULT_ENDPOINT = "https://the-one-api.dev/"
    VERSION = "v2"
    ALLOWED_QUERY_KEYS = %i[page limit offset].freeze

    attr_reader :access_token, :endpoint, :version

    def initialize(access_token:, endpoint: DEFAULT_ENDPOINT, version: VERSION)
      @endpoint = endpoint
      @access_token = access_token
      @version = version
    end

    def api_request(path, query = {})
      query_string = ALLOWED_QUERY_KEYS.intersection(query.keys).map { |k| "#{k}=#{query[k]}" }.join("&")
      uri = URI("#{endpoint}#{version}#{path}?#{query_string}")

      headers = {
        "Authorization" => "Bearer #{access_token}",
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }

      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = uri.instance_of? URI::HTTPS
      res = http.get(uri.request_uri, headers)

      # value (weird name) will raise if the response code is not 200
      res.value
      JSON.parse(res.body)["docs"]
    end
  end
end
