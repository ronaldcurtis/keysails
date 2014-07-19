keystone = require('keystone')
includeAll = require('include-all')
path = require('path')

# Load your project's Models
modelBlueprints = keystone.import('api/models')

controllers = includeAll
  dirname     : path.join(__dirname, '../api/controllers')
  filter      : /(.+Controller)\.coffee$/
  excludeDirs : /^\.(git|svn)$/
  optional    : true

policies = includeAll
  dirname     : path.join(__dirname, '../api/policies')
  filter      : /(.*)\.coffee$/
  excludeDirs : /^\.(git|svn)$/
  optional    : true

config = includeAll
  dirname     : path.join(__dirname, '../config')
  filter      : /(.*)\.coffee$/
  excludeDirs : /^\.(git|svn)$/
  optional    : true

deepFreeze = (o) ->
  Object.freeze(o)
  for propKey,prop of o
    prop = o[propKey]
    if !o.hasOwnProperty(propKey) || !(typeof prop == "object") || Object.isFrozen(prop)
      continue
    deepFreeze(prop)

# Deep Freeze Config
deepFreeze(config)

# Create Object to pass around
data = config: config, policies: policies, controllers: controllers, modelBlueprints: modelBlueprints

console.log('\n\nmodel blueprints', modelBlueprints)
console.log('\n\ncontrollers', controllers)
console.log('\n\npolicies', policies)
console.log('\n\nconfig', config)

# Add CRUD methods to model controllers
require('./addCrud')(data)

console.log('\n\ncontrollers after crud', controllers)

# Create Policies and Controllers Object
policiesAndControllers = require('./setPolicies')(data)

console.log('\n\nPoliciesAndControllers', policiesAndControllers)

# Set Rest Routes, and all other routes
module.exports = (app) ->
  data.app = app
  data.policiesAndControllers = policiesAndControllers
  # require('./setRestRoutes.coffee')(data)