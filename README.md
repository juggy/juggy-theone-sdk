# Theone

Ruby SDK implementation for [The One API](https://the-one-api.dev/documentation)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add juggy-theone-sdk

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install juggy-theone-sdk

## Usage

Once the gem is installed, you can query movies and quotes like so:

```
sdk = Theone::Sdk.new(access_token: "my access token")
```

The SDK can be configured with different endpoint and api version as such

```
sdk = Theone::Sdk.new(
        access_token: "my access token"
        endpoint: "https://example.com",
        version: "v3"
    )
```
This can be useful if you plan on using a test endpoint or an image hosted elsewhere.

Once you have a valid SDK object, you can access Movies:

```
# get all movies, pagination is handled for you.
sdk.movies

# get a specific movie
my_movie = sdk.movie(movie_id)

# access the movie attributes like so
my_movie.name
# or all movie attributes
my_movie.attributes
```

Or Quotes:
```
# get all quotes, pagination is handled for you.
sdk.quotes

# get a specific quote
my_quote = sdk.quote(quote_id)

# access the quote attributes like so
my_quote.name
# or all quote attributes
my_quote.attributes
```

You can also get all quotes from a specific movie:
```
my_movie = sdk.movie(movie_id)
my_movie.quotes.first
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/juggy/juggy-theone-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
