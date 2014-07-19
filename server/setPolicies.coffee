# Setup Policies
module.exports = (controllers, policies) ->
  _                      = require('lodash')
  typeCheck              = require('type-check').typeCheck
  policiesAndControllers = _.cloneDeep(controllers)

  # First place all controller actions into an array
  do ->
    for controllerName, controller of policiesAndControllers
      for actionName, action of controller
        if !typeCheck('Array', action)
          policiesAndControllers[controllerName][actionName] = [action]

  # Adds functions to the front of the controller action
  addToControllerAction = (controller, action, fns) ->
    if !typeCheck('[Function]', fns)
      throw Error('addToControllerAction: expected array of functions.')
    if !controller
      throw Error('addToControllerAction: Controller is undefined')
    if !controller[action]
      throw Error("addToControllerAction: Controller action #{action} is undefined")
    if !typeCheck('Array', controller[action])
      controller[action] = [controller[action]]
    controller[action] = fns.concat(controller[action])

  # Adds functions to the front of all controller actions
  addToAllControllerActions = (controller, fns) ->
    if !typeCheck('[Function]', fns)
      throw Error('addToAllControllerActions: expected array of functions.')
    if !controller
      throw Error('addToAllControllerActions: Controller is undefined')
    for action,value of controller
      addToControllerAction(controller,action,fns)

  if typeCheck('Object', policies)
    for controller,actions of Config.policies
      # Chek if controller exists
      if !policiesAndControllers[controller]
        throw Error("Config.policies: Controller #{controller} does not exist")

      #Util to reference policy functions in array
      makePolicyArray = (policyNamesToApply) ->
        policyFns = []
        if typeCheck('String', policyNamesToApply)
          policyNamesToApply = [policyNamesToApply]
        for policyName in policyNamesToApply
          if !policies[policyName]
            throw Error("Config.policies: policy #{policyName} does not exist")
          policyFns.push policies[policyName]
        return policyFns

      # Add policies for specific actions only first
      do ->
        for action, policyNamesToApply of actions
          if action != "*"
            # Check if controller action exists
            if !policiesAndControllers[controller][action]
              throw Error("Config.policies: Controller action #{controller}.#{action} does not exist")

            policyFns = makePolicyArray(policyNamesToApply)
            addToControllerAction(policiesAndControllers[controller], action, policyFns)

      # Add policies to * actions if specified. This must be done last
      do ->
        for action, policyNamesToApply of actions
          if action == "*"
            policyFns = makePolicyArray(policyNamesToApply)
            addToAllControllerActions(policiesAndControllers[controller], policyFns)

  return policiesAndControllers
