###*
 * Function that adds CRUD methods to a model's controller object
 * @param data Contains information about existing models and config settings for rest
 * @param data.modelBlueprints contains model config settings for defined models
 * @param data.controllers contains defined controller objects
 * @param data.config contains settings pertaining to whether rest is enabled or not
###
module.exports = (data) ->
  _               = require('lodash')
  typeCheck       = require('type-check').typeCheck
  modelBlueprints = data.modelBlueprints
  controllers     = data.controllers
  config          = data.config

  addCrud = (srcObject, crudObject) ->
    if !typeCheck('Object', srcObject)
      throw Error "addCrud: expected srcObject to be object but got: #{obj}"
    if !typeCheck('Object', crudObject)
      throw Error "addCrud: expected crudObject to be object but got: #{obj}"
    if !typeCheck('{ create: Function, read: Function, update: Function, delete: Function }', crudObject)
      throw Error "addCrud: expected crudObject to be object with create, read, update properties of type Function"
    _.defaults srcObject, crudObject

  restConfig = config.rest

  for modelName, blueprint of modelBlueprints
    controllerName = modelName + 'Controller'

    # if no controller exists, create and add it to controllers
    if !controllers[controllerName]
      if (restConfig.enabled && blueprint.rest == undefined) || blueprint.rest
        newController = {}
        addCrud(newController, restConfig.crud(modelName))
        controllers[controllerName] = newController

    # If it does exist, then addCrud methods if they dont exist
    else if (restConfig.enabled && blueprint.rest == undefined) || blueprint.rest
      addCrud(controllers[controllerName], restConfig.crud(modelName))
