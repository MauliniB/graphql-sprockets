# GraphQL::Sprockets

🚧 Under Construction 🚧

A usage pattern for GraphQL & Rails (or another Sprockets environment).

- Add `.graphql` files to the asset pipeline
- Require `.graphql` files within JavaScript to register those queries on client & server
- Invoke cached queries by name from the client

The included JavaScript client can also send ad-hoc GraphQL queries.

#### Goals

- Highly stable system for client-server communication
- Fail-fast development process
- Simple, efficient Rails integration

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-sprockets'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-sprockets

## Usage

- Define a GraphQL schema and assign it to `GraphQL::Sprockets.schema`:

  ```ruby
  MyGraphQLSchema = GraphQL::Schema.new(...)
  GraphQL::Sprockets.schema = MyGraphQLSchema
  ```

- Add `.graphql` files in `app/assets/javascripts`, for exmample:

  ```graphql
  # app/assets/javascripts/queries/getBandMembers.graphql
  query getBandMembers($bandId: Int!) {
    band(id: $bandId) {
      members {
        firstName
        lastName
        hometown
        instruments {
          name
          playedFrom
          playedTo
        }
      }
    }
  }
  ```
- Require `graphql-sprockets` and the `.graphql` file in `application.js`:

  ```javascript
  //= require graphql-sprockets
  //= require getBandMembers.graphql
  ```

- In your JavaScript code, invoke the saved query with its arguments:

  ```javascript
  GraphQLSprockets.getBandMembers({bandId: 1001})
    .then(function(graphQLResponseJSON) {
      _this.setState({bandMembers: graphQLResponseJSON.data.band.members})
    })
  ```

#### Dependency: `window.fetch`

`graphql-sprockets` uses the global `fetch` function for making AJAX requests. To support older browsers, you can include a polyfill from this project:

```js
//= require graphql-sprockets/fetch
```

## Todo

- Test: `.graphql` registers the query with a GraphQL::QueryCache
- Test: invoking named queries works
- Test: the client can also send arbitrary queries
- If you change Ruby code but _don't_ reload the page, it clears the cache. Somehow, we have to refill it.
- Document & improve endpoint customization

## Development

- Run the tests with `bundle exec rake test`

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
