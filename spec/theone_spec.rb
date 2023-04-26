# frozen_string_literal: true

RSpec.describe Theone do
  it "has a version number" do
    expect(Theone::VERSION).not_to be nil
  end

  describe Theone::Sdk do
    subject { Theone::Sdk.new(access_token: "123", endpoint: "http://example.com/") }
    let(:movies_body) do
      "{\"docs\":[{\"_id\":\"5cd95395de30eff6ebccde56\",\"name\":\"The Lord of the Rings Series\"},{\"_id\":\"5cd95395de30eff6ebccde57\",\"name\":\"The Hobbit Series\"},{\"_id\":\"5cd95395de30eff6ebccde58\",\"name\":\"The Unexpected Journey\"},{\"_id\":\"5cd95395de30eff6ebccde59\",\"name\":\"The Desolation of Smaug\"},{\"_id\":\"5cd95395de30eff6ebccde5a\",\"name\":\"The Battle of the Five Armies\"},{\"_id\":\"5cd95395de30eff6ebccde5b\",\"name\":\"The Two Towers\"},{\"_id\":\"5cd95395de30eff6ebccde5c\",\"name\":\"The Fellowship of the Ring\"},{\"_id\":\"5cd95395de30eff6ebccde5d\",\"name\":\"The Return of the King\"}],\"total\":8,\"limit\":1000,\"offset\":0,\"page\":1,\"pages\":1}"
    end
    let(:movie_body) do
      "{\"docs\":[{\"_id\":\"1\",\"name\":\"The Lord of the Rings Series\"}],\"total\":1,\"limit\":1000,\"offset\":0,\"page\":1,\"pages\":1}"
    end
    let(:quotes_body) do
      "{\"docs\":[{\"_id\": \"5cd96e05de30eff6ebcce8e3\",\"dialog\": \"One that is cursed. Long ago the men of the mountains swore an oath to the last King of Gondor, to come to his aid, to fight. But when the time came, when Gondor's need was dire, they fled vanishing into the darkness of the mountain. And so Isildur cursed them, never to rest until they had fulfilled their pledge. Who shall call them from the grey twilight, the forgotten people? The heir of him to whom the oath they swore. From the North shall he come, need shall drive him. He shall pass the door to the Paths of the Dead.\",\"movie\": \"5cd95395de30eff6ebccde5d\",\"character\": \"5cd99d4bde30eff6ebccfd81\",\"id\": \"5cd96e05de30eff6ebcce8e3\"},{\"_id\": \"5cd96e05de30eff6ebcce8e7\",\"dialog\": \"The way is shut. It was made by those who are dead, and the dead keep it. The way is shut.\",\"movie\": \"5cd95395de30eff6ebccde5d\",\"character\": \"5cd99d4bde30eff6ebccfd81\",\"id\": \"5cd96e05de30eff6ebcce8e7\"},{\"_id\": \"5cd96e05de30eff6ebcce900\",\"dialog\": \"I see shapes of men and of horses.\",\"movie\": \"5cd95395de30eff6ebccde5d\",\"character\": \"5cd99d4bde30eff6ebccfd81\",\"id\": \"5cd96e05de30eff6ebcce900\"},{\"_id\": \"5cd96e05de30eff6ebcce902\",\"dialog\": \"Pale banners like shreds of cloud. Spears rise like winter thickets through a shroud of mist. The dead are following. They have been summoned.\",\"movie\": \"5cd95395de30eff6ebccde5d\",\"character\": \"5cd99d4bde30eff6ebccfd81\",\"id\": \"5cd96e05de30eff6ebcce902\"},{\"_id\": \"5cd96e05de30eff6ebcce922\",\"dialog\": \"The horses are restless and the men are quiet.\",\"movie\": \"5cd95395de30eff6ebccde5d\",\"character\": \"5cd99d4bde30eff6ebccfd81\",\"id\": \"5cd96e05de30eff6ebcce922\"}],\"total\":4,\"limit\":1000,\"offset\":0,\"page\":1,\"pages\":1}"
    end
    let(:quote_body) do
      "{\"docs\":[{\"_id\": \"1\", \"dialog\": \"Reforge the sword' ada.\", \"movie\": \"5cd95395de30eff6ebccde5d\", \"character\": \"5cd99d4bde30eff6ebccfc07\",\"id\": \"5cd96e05de30eff6ebccefbe\"}],\"total\":1,\"limit\":1000,\"offset\":0,\"page\":1,\"pages\":1}"
    end

    describe Theone::Movie do
      before do
        stub_request(:get, "http://example.com/v2/movie")
          .with(headers: { "Authorization" => "Bearer 123" }, query: { "page" => "1", "limit" => "10" })
          .to_return(body: movies_body)
        stub_request(:get, "http://example.com/v2/movie/1")
          .with(headers: { "Authorization" => "Bearer 123" })
          .to_return(body: movie_body)
        stub_request(:get, "http://example.com/v2/movie/1/quote")
          .with(headers: { "Authorization" => "Bearer 123" }, query: { "page" => "1", "limit" => "10" })
          .to_return(body: quotes_body)
      end

      it "lists all movies" do
        movies = subject.movies
        expect(movies.to_a.size).to eq(8)
        expect(movies.first.name).to eq("The Lord of the Rings Series")
      end

      it "shows one movie" do
        movie = subject.movie(1)
        expect(movie.name).to eq("The Lord of the Rings Series")
      end

      it "lists all quotes from movie" do
        movie = subject.movie(1)
        quotes = movie.quotes
        expect(quotes.to_a.size).to eq(5)
        expect(quotes.first.dialog).to eq("One that is cursed. Long ago the men of the mountains swore an oath to the last King of Gondor, to come to his aid, to fight. But when the time came, when Gondor's need was dire, they fled vanishing into the darkness of the mountain. And so Isildur cursed them, never to rest until they had fulfilled their pledge. Who shall call them from the grey twilight, the forgotten people? The heir of him to whom the oath they swore. From the North shall he come, need shall drive him. He shall pass the door to the Paths of the Dead.")
      end
    end

    describe Theone::Quote do
      before do
        stub_request(:get, "http://example.com/v2/quote")
          .with(headers: { "Authorization" => "Bearer 123" }, query: { "page" => "1", "limit" => "10" })
          .to_return(body: quotes_body)
        stub_request(:get, "http://example.com/v2/quote/1")
          .with(headers: { "Authorization" => "Bearer 123" })
          .to_return(body: quote_body)
      end

      it "lists all quotes" do
        quotes = subject.quotes
        expect(quotes.to_a.size).to eq(5)
        expect(quotes.first.dialog).to eq("One that is cursed. Long ago the men of the mountains swore an oath to the last King of Gondor, to come to his aid, to fight. But when the time came, when Gondor's need was dire, they fled vanishing into the darkness of the mountain. And so Isildur cursed them, never to rest until they had fulfilled their pledge. Who shall call them from the grey twilight, the forgotten people? The heir of him to whom the oath they swore. From the North shall he come, need shall drive him. He shall pass the door to the Paths of the Dead.")
      end

      it "shows one quote" do
        quote = subject.quote(1)
        expect(quote.dialog).to eq("Reforge the sword' ada.")
      end
    end
  end
end
