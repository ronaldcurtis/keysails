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

# Create Object to pass around
data = config: config, policies: policies, controllers: controllers, modelBlueprints: modelBlueprints

# Add CRUD methods to model controllers
require('./addCrud')(data)

# Create Policies and Controllers Object
policiesAndControllers = require('./setPolicies')(data)

# Set Middleware
require('./setMiddleware')(data)

# Set Middleware, Rest Routes, and all other routes
module.exports = (app) ->
  data.app = app
  data.policiesAndControllers = policiesAndControllers
  require('./setRestRoutes.coffee')(data)
  require('./setRoutes')(data)





