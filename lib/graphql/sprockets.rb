require "sprockets"
require "graphql"
require "graphql/sprockets/version"
require "graphql/sprockets/processor"
if defined?(Rails)
  require "graphql/sprockets/engine"
end

module GraphQL
  module Sprockets
    class << self
      attr_accessor :schema
    end
  end
end
