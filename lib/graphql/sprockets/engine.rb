module GraphQL
  module Sprockets
    class Engine < ::Rails::Engine
      ::Sprockets.register_mime_type 'text/graphql', extensions: ['.graphql']
      ::Sprockets.register_transformer 'text/graphql', 'application/javascript', GraphQL::Sprockets::Processor

      config.to_prepare do
        GraphQL::Sprockets::Processor.reset
      end
    end
  end
end
