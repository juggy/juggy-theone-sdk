# frozen_string_literal: true

require "json"

RSpec.describe Theone::Paginator do
  subject { described_class.paginate(client, "/movie", limit: 3) { |json| Theone::Movie.new(client, json) } }
  let(:client) { Theone::Client.new access_token: "123", endpoint: "http://example.com/" }
  let(:json) do
    "{\"docs\":[{\"_id\":\"5cd95395de30eff6ebccde56\",\"name\":\"The Lord of the Rings Series\"},{\"_id\":\"5cd95395de30eff6ebccde57\",\"name\":\"The Hobbit Series\"},{\"_id\":\"5cd95395de30eff6ebccde58\",\"name\":\"The Unexpected Journey\"},{\"_id\":\"5cd95395de30eff6ebccde59\",\"name\":\"The Desolation of Smaug\"},{\"_id\":\"5cd95395de30eff6ebccde5a\",\"name\":\"The Battle of the Five Armies\"},{\"_id\":\"5cd95395de30eff6ebccde5b\",\"name\":\"The Two Towers\"},{\"_id\":\"5cd95395de30eff6ebccde5c\",\"name\":\"The Fellowship of the Ring\"},{\"_id\":\"5cd95395de30eff6ebccde5d\",\"name\":\"The Return of the King\"}],\"total\":8,\"limit\":1000,\"offset\":0,\"page\":1,\"pages\":1}"
  end
  let(:movies) { JSON.parse(json)["docs"] }

  let(:body1) { JSON.dump({ docs: [movies[0], movies[1], movies[2]] }) }
  let(:body2) { JSON.dump({ docs: [movies[3], movies[4], movies[5]] }) }
  let(:body3) { JSON.dump({ docs: [movies[6], movies[7]] }) }

  before do
    stub_request(:get, "http://example.com/v2/movie")
      .with(query: { "page" => "1", "limit" => "3" })
      .to_return(body: body1)
    stub_request(:get, "http://example.com/v2/movie")
      .with(query: { "page" => "2", "limit" => "3" })
      .to_return(body: body2)
    stub_request(:get, "http://example.com/v2/movie")
      .with(query: { "page" => "3", "limit" => "3" })
      .to_return(body: body3)
  end

  it "loads all pages" do
    subject.each_with_index do |movie, index|
      expect(movie.id).to eq(movies[index]["_id"])
    end
  end
end
