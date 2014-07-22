# Set REST Routes if enabled
module.exports = (data) ->
	app                    = data.app
	restConfig             = data.config.rest
	modelBlueprints        = data.modelBlueprints
	policiesAndControllers = data.policiesAndControllers
	prefix                 = restConfig.prefix || '/api'
	path                   = require('path')

	for modelName, Model of modelBlueprints
		if (restConfig.enabled && Model.rest == undefined) || Model.rest
			controllerName = modelName + 'Controller'
			controller = policiesAndControllers[controllerName]
			# If crud method does not exist, then throw error
			for methodName in ['read', 'create', 'update', 'delete']
				if !controller[methodName]
					throw Error "setRestRoutes: crud method #{controllerName}.#{methodName} does not exist"
			app.get path.join(prefix, "/#{modelName.toLowerCase()}/:id?"), controller.read
			app.post path.join(prefix, "/#{modelName.toLowerCase()}"), controller.create
			app.put path.join(prefix, "/#{modelName.toLowerCase()}/:id"), controller.update
			app.delete path.join(prefix, "/#{modelName.toLowerCase()}/:id"), controller.delete
