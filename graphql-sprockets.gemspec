# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/sprockets/version'

Gem::Specification.new do |spec|
  spec.name          = "graphql-sprockets"
  spec.version       = GraphQL::Sprockets::VERSION
  spec.authors       = ["Robert Mosolgo"]
  spec.email         = ["rdmosolgo@gmail.com"]

  spec.summary       = "Use Sprockets to integrate GraphQL with Rails"
  spec.description   = "Add .graphql files to the asset pipeline. This causes them to be cached on the server but executable from the client."
  spec.homepage      = "http://github.com/rmosolgo/graphql-sprockets"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.1.0' # bc optional keyword args

  spec.add_runtime_dependency "graphql"
  spec.add_runtime_dependency "sprockets", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
