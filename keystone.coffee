# Set environment variables from .env
require('dotenv').load()
keystone = require('keystone')

# Initialise Keystone with your project's configuration.
# See http://keystonejs.com/guide/config for available options
# and documentation.

keystone.init

	'name': 'keysails'
	'brand': 'keysails'

	'less': 'public'
	'static': 'public'
	'favicon': 'public/favicon.ico'
	'views': 'templates/views'
	'view engine': 'jade'
	
	'auto update': true
	'session': true
	'auth': true
	'user model': 'User'
	'cookie secret': 'g!9u07f$~,*"T^E}vn5Nfr6Q*/wO^TMf*^O7g>F)[{]nm@A2HW5qa^2`W`d+Lr`)'

# Load your project's Models
modelBlueprints = keystone.import('api/models')

controllers = require('include-all')
  dirname     :  __dirname + '/api/controllers'
  filter      :  /(.+Controller)\.coffee$/
  excludeDirs :  /^\.(git|svn)$/
  optional: true

policies = require('include-all')
  dirname: __dirname + '/api/policies'
  filter      :  /(.*)\.coffee$/
  excludeDirs :  /^\.(git|svn)$/
  optional: true

config = require('include-all')
  dirname: __dirname + '/config'
  filter      :  /(.*)\.coffee$/
  excludeDirs :  /^\.(git|svn)$/
  optional: true

deepFreeze = (o) ->
  Object.freeze(o)
  for propKey,prop of o
    prop = o[propKey]
    if !o.hasOwnProperty(propKey) || !(typeof prop == "object") || Object.isFrozen(prop)
      continue
    deepFreeze(prop)

# Make Config Global and freeze it
global.Config = config
deepFreeze(global.Config)

console.log('model blueprints', modelBlueprints)
console.log('controllers', controllers)
console.log('policies', policies)
console.log('config', config)

# Add CRUD methods to model controllers
require('./server/addCrud')(modelBlueprints, controllers)

console.log('controllers after crud', controllers)

# Setup common locals for your templates. The following are required for the
# bundled templates and layouts. Any runtime locals (that should be set uniquely
# for each request) should be added to ./routes/middleware.js

keystone.set 'locals',
	_: require('underscore')
	env: keystone.get('env')
	utils: keystone.utils
	editable: keystone.content.editable

#  Load your project's Routes

keystone.set('routes', require('./routes'))

# Configure the navigation bar in Keystone's Admin UI

keystone.set 'nav',
	'users': 'users'
	'pages': 'pages'

# Start Keystone to connect to your database and initialise the web server

keystone.start () ->
	# Page = keystone.list('Page')
 
	# newPage = new Page.model
	# 	title: 'New Post'
	 
	# newPage.save (err,doc) ->
	# 	console.log('newPage Saved')
	# 	console.log(Page)
				
