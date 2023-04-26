# Design

## Dependencies

This gem uses the default Ruby HTTP client and JSON parser. It was a concious decision to avoid forcing the consumer to bring more dependencies in order to use the SDK.

## Object Model

The object model uses a base class and can handle any type of data. The base class relies on `method_missing` to link the json attributes to real method calls. There is no further interpretation of the JSON data. In fact each type (Movie or Quote) does not implement specific logic for the data. A differenciation can be added in the futur as the types are loaded and defined.

## Pagination

The pagination is handled using an `Enumerator` which makes it transparent to the SDK consumer. A nice side effect of using an `Enumerator` is that the data is lazily loaded. This allows for a better use of resources.

It also provides a central place to implement throtling mitigation (as the API is limited to 100 calls per 10 minutes). This would be a futur improvement.

