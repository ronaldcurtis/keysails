module.exports = (modelBlueprints, controllers) ->
  _       = require('underscore')
  check   = require('check-types')

  addCrud = (srcObject, crudObject) ->
    _.defaults srcObject, crudObject

  restConfig = Config.rest

  for modelName, blueprint of modelBlueprints
    controllerName = modelName + 'Controller'

    # if no controller exists, create and add it to controllers
    if !controllers[controllerName]
      if (restConfig.enabled && blueprint.rest == undefined) || blueprint.rest
        newController = {}
        addCrud(newController, restConfig.methods)
        controllers[controllerName] = newController

    # If it does exist, then addCrud methods if they dont exist
    else if (restConfig.enabled && blueprint.rest == undefined) || blueprint.rest
      addCrud(contollers[controllerName], restConfig.methods)
