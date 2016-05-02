NIL_RETURN = -> (_o, _a, _c) { nil }

def constant_value(const_name)
  -> (_o, _a, _c) { Object.const_get(const_name) }
end

RubyType = GraphQL::ObjectType.define do
  name "Ruby"
  description "Information about the Ruby runtime"

  field :version, types.String do
    resolve(constant_value(:RUBY_VERSION))
  end

  field :patchlevel, types.String do
    resolve(constant_value(:RUBY_PATCHLEVEL))
  end
end

RubyObjectType = GraphQL::ObjectType.define do
  field :const_get, types.String do
    argument :name, !types.String
    resolve -> (obj, args, ctx) {
      obj.const_get(args[:name]).to_s
    }
  end
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  field :ruby, RubyType do
    resolve(NIL_RETURN)
  end

  field :object, RubyObjectType do
    resolve(constant_value(:Object))
  end
end

RubySchema = GraphQL::Schema.new(query: QueryType)
