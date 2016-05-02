module GraphQL
  module Sprockets
    class Processor
      class << self
        # Accept a GraphQL query, return JavaScript code
        # The query must have one operation definition and it must be named.
        def call(input)
          query_string = input[:data]

          # Cache the query:
          graphql_schema.cache(query_string)

          # Generate a JS representation:
          query = GraphQL::Query.new(graphql_schema, query_string)
          query.operations.reduce("") do |output, (name, operation)|
            output << js_code(input[:filename], operation)
          end
        end

        # Clear the query cache and reset asset reloading
        def reset
          graphql_schema.query_cache.clear
          @cache_key = nil
        end

        # Any time the schema changes, we need to reload all the queries,
        # so this cache_key is application-dependent!
        def cache_key
          @cache_key ||= Time.now.to_i
        end

        private

        # Generate the client-side code for a given GraphQL::Language::Nodes::OperationDefinition
        def js_code(file_name, operation)

          %|// Compiled from #{file_name}
GraphQLSprockets.registerNamedOperation(
  // Invoked by this name:
  "#{operation.name}",
  // May use these variables:
  [#{operation.variables.map {|var| print_variable(var) }.join(", ")}]
)
          |
        end

        def print_variable(ast_variable)
          graphql_type = graphql_schema.type_from_ast(ast_variable.type)
          %|{name: "#{ast_variable.name}", nonNull: #{graphql_type.kind.non_null? }}|
        end

        def graphql_schema
          GraphQL::Sprockets.schema
        end
      end
    end
  end
end
