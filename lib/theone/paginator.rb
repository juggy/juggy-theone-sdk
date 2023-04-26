# frozen_string_literal: true

module Theone
  # iterator class to provide transparent pagination
  module Paginator
    def self.paginate(client, path, page: 1, limit: 10, &block)
      Enumerator.new do |y|
        loop do
          data = client.api_request(path, page: page, limit: limit)

          data.each do |element|
            object = block.call element
            y.yield object
          end

          # stop if empty
          break if data.empty? || data.size < limit

          # go to next page
          page += 1
        end
      end
    end
  end
end
