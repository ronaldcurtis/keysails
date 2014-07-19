module.exports = (modelBlueprints, controllers, config) ->
  _         = require('lodash')
  typeCheck = require('type-check').typeCheck

  addCrud = (srcObject, crudObject) ->
    if !typeCheck('Object', srcObject)
      throw Error "addCrud: expected srcObject to be object but got: #{obj}"
    if !typeCheck('Object', crudObject)
      throw Error "addCrud: expected crudObject to be object but got: #{obj}"
    _.defaults srcObject, crudObject

  restConfig = config.rest

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
      addCrud(controllers[controllerName], restConfig.methods)
