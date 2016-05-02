if (!window.fetch) {
  console.warn("GraphQLSprockets depends on a global 'fetch' function, see the Readme for more information.")
}

var GraphQLSprockets = {
  HTTP_METHOD: "POST",
  ENDPOINT_PATH: "/graphql",
  namedOperations: [],
  // Define a function with this name which expects these arguments
  registerNamedOperation: function(operationName, variableSpecs) {
    this.namedOperations.push(operationName)
    this[operationName] = this._createNamedOperation(operationName, variableSpecs)
  },

  // Execute an arbitrary query.
  // In the case of a server-side query, the query string may be blank
  // Options:
  // - variables: query argument values
  // - operationName: the operation to execute (maybe in `queryString`, maybe on the server)
  execute: function(queryString, options) {
    if (!options) {
      options = {}
    }

    var payload = {}

    queryString && (payload.query = queryString)
    options.variables && (payload.variables = options.variables)
    options.operationName && (payload.operationName = options.operationName)

    // console.log("EXECUTE!", payload, queryString, options)

    var fetchPromise = fetch(this.ENDPOINT_PATH, {
      method: this.HTTP_METHOD,
      body: JSON.stringify(payload),
      credentials: "include",
    })
    return fetchPromise.then(function(response) { return response.json() })
  },

  _createNamedOperation: function(operationName, variableSpecs) {
    var _this = this
    var requiredVariableSpecs = variableSpecs.filter(function(spec) { return spec.nonNull })
    return function(providedVariables) {
      // First, check the variables
      var missingVariables = requiredVariableSpecs.filter(function(spec) { return providedVariables[spec.name] == null })
      if (missingVariables.length) {
        throw(new Error("GraphQL query '" + operationName + "' is missing required variables: " + missingVariables.join(", ")))
      }
      // Then, send the query
      return _this.execute("", {
        variables: providedVariables,
        operationName: operationName
      })
    }
  },
}
