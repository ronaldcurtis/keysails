# Set REST Routes if enabled
exports = module.exports = (data) ->
	app = data.app
	restConfig = data.config.rest
	modelBlueprints = data.modelBlueprints
	policiesAndControllers = data.policiesAndControllers
	prefix = restConfig.prefix || '/api'
	path = require('path')

	for modelName, Model of modelBlueprints
		console.log("model.rest", Model.rest)
		if (restConfig.enabled && Model.rest == undefined) || Model.rest
			controllerName = modelName + 'Controller'
			console.log("ControllerName:", controllerName)
			controller = policiesAndControllers[controllerName]
			app.get path.join(prefix, "/#{modelName.toLowerCase()}/:id?"), controller.read
			app.post path.join(prefix, "/#{modelName.toLowerCase()}"), controller.create
			app.put path.join(prefix, "/#{modelName.toLowerCase()}/:id"), controller.update
			app.delete path.join(prefix, "/#{modelName.toLowerCase()}/:id"), controller.delete
