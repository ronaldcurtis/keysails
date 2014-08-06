###*
 * Function that sets routes as defined in config/routes.coffee
 * @param data Contains information about existing models and config settings for rest
 * @param data.app points to express application instance
 * @param data.policiesAndControllers object containing transformed controllers with any policies attached
 * @param data.config contains REST configuration and REST prefix
 * @param data.routes contains route configuration
###
module.exports = (data) ->
	typeCheck              = require('type-check').typeCheck
	app                    = data.app
	config                 = data.config
	policiesAndControllers = data.policiesAndControllers
	routes                 = config.routes
	keystone               = data.keystone

	createStaticController = (view) ->
		return staticController = (req,res) ->
			newView = new keystone.View(req, res)
			newView.render(view)

	for key,value of routes
		if key == "staticRoutes"
			if !typeCheck('Object', value)
				throw Error "config.routes: #{key} should be an object"

			for path,view of value
				if !typeCheck('String', view)
					throw Error "config.routes: staticRoutes['#{path}'] should be a string"
				staticController = createStaticController(view)
				app.all(path, staticController)


		else
			if !typeCheck("String", value)
				throw Error "config.routes: #{key} should be a string"
				
			keyArray = key.trim().split(' ')
			valueArray = value.trim().split('.')
			verb = keyArray[0].toLowerCase()
			path = keyArray[1].toLowerCase()
			controller = valueArray[0]
			action = valueArray[1]

			if !policiesAndControllers[controller] then throw Error("config.routes: Controller #{controller} does not exist")
			if !policiesAndControllers[controller][action] then throw Error("config.routes: Controller action #{controller}.#{action} does not exist")

			app[verb](path, policiesAndControllers[controller][action])