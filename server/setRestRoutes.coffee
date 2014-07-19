# Set REST Routes if enabled
exports = module.exports = (app) ->
	restConfig = _CONFIG.rest
  prefix = restConfig.prefix || '/api'
  path = require('path')
  
  for modelName, Model of _MODEL_BLUEPRINTS
    if (restConfig.enabled && Model.rest == undefined) || Model.rest
      controllerName = modelName + 'Controller'
      controller = policiesAndControllers[controllerName]
      app.get path.join(prefix,'/:model/:id?'), controller.read
      app.post path.join(prefix,'/:model'), controller.create
      app.put path.join(prefix,'/:model/:id'), controller.update
      app.delete path.join(prefix,'/:model/:id'), controller.delete
