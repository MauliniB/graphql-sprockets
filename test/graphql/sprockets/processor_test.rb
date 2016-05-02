require "test_helper"

class GraphQL::Sprockets::ProcessorTest < Minitest::Test
  TEST_FILENAME = "my/file.graphql"
  TEST_QUERY = %|
  query getConstant($constantName: String!, $otherConstantName: String = "Time") {
    object {
      const_get(name: $constantName)
      otherConst: const_get(name: $otherConstantName)
    }
  }
  |

  def setup
    GraphQL::Sprockets.schema = RubySchema
  end

  def teardown
    GraphQL::Sprockets.schema = nil
    RubySchema.query_cache.clear
  end

  def get_result(filename, contents)
    GraphQL::Sprockets::Processor.call(filename: filename, data: contents)
  end

  def test_converts_graphql_queries_to_function_calls
    result = get_result(TEST_FILENAME, TEST_QUERY)
    assert_includes(result, 'GraphQLSprockets.registerNamedOperation(')
  end

  def test_it_registers_the_operation_name
    result = get_result(TEST_FILENAME, TEST_QUERY)
    assert_includes(result, '"getConstant"')
  end

  def test_it_registers_the_arguments
    result = get_result(TEST_FILENAME, TEST_QUERY)
    assert_includes(result, '[{name: "constantName", nonNull: true}, {name: "otherConstantName", nonNull: false}]')
  end

  def test_it_registers_the_file_name
    result = get_result(TEST_FILENAME, TEST_QUERY)
    assert_includes(result, "Compiled from my/file.graphql")
  end

  def test_it_caches_the_query_on_the_server
    assert_equal 0, RubySchema.query_cache.size
    result = get_result(TEST_FILENAME, TEST_QUERY)
    assert_equal 1, RubySchema.query_cache.size
  end

  INVALID_FIELD_QUERY = %|
    query invalidQuery {
      nonSenseField
    }
  |

  NO_OPERATION_NAME_QUERY = %|{ ruby { version } }|

  def test_it_raises_on_invalid_query
    assert_raises { get_result(TEST_FILENAME, INVALID_FIELD_QUERY) }
    assert_raises { get_result(TEST_FILENAME, NO_OPERATION_NAME_QUERY) }
  end

  MULTIPLE_OPS_QUERY = %|
    query getConstant($constantName: String!) {
      object {
        const_get(name: $constantName)
      }
    }

    query getVersion {
      ruby {
        version
      }
    }
  |
  def test_it_stores_multiple_operations
    assert_equal 0, RubySchema.query_cache.size
    result = get_result(TEST_FILENAME, MULTIPLE_OPS_QUERY)
    assert_equal 2, RubySchema.query_cache.size
    assert_includes(result, '"getConstant"')
    assert_includes(result, '"getVersion"')
  end
end
