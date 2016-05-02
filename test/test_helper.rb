$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'graphql/sprockets'

require 'minitest/autorun'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
