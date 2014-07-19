# Setup Policies
module.exports = (data) ->
  _                      = require('lodash')
  typeCheck              = require('type-check').typeCheck
  controllers            = data.controllers
  policies               = data.policies
  config                 = data.config
  policiesAndControllers = _.cloneDeep(controllers)

  # First place all controller actions into an array
  do ->
    for controllerName, controller of policiesAndControllers
      for actionName, action of controller
        if !typeCheck('Array', action)
          policiesAndControllers[controllerName][actionName] = [action]

  # Adds functions to the front of the controller action
  addPolicies = (controller, action, fns) ->
    if !typeCheck('[Function]', fns)
      throw Error('addPolicies: expected array of functions.')
    if !controller
      throw Error('addPolicies: Controller is undefined')
    if !controller[action]
      throw Error("addPolicies: Controller action #{action} is undefined")
    if !typeCheck('Array', controller[action])
      controller[action] = [controller[action]]
    controller[action] = fns.concat(controller[action])

  # Adds functions to the front of all controller actions that don't currently have a func
  addDefaultPolicies = (controller, fns) ->
    if !typeCheck('[Function]', fns)
      throw Error('addDefaultPolicies: expected array of functions.')
    if !controller
      throw Error('addDefaultPolicies: Controller is undefined')
    for action,value of controller
      if (value.length == 1)
        addPolicies(controller,action,fns)

  # Loop through policy config and apply policies
  if typeCheck('Object', policies)
    for controller,actions of config.policies
      # Chek if controller exists
      if !policiesAndControllers[controller]
        throw Error("config.policies: Controller #{controller} does not exist")

      #Util to reference policy functions in array
      makePolicyArray = (policyNamesToApply) ->
        policyFns = []
        if typeCheck('String', policyNamesToApply)
          policyNamesToApply = [policyNamesToApply]
        for policyName in policyNamesToApply
          if !policies[policyName]
            throw Error("config.policies: policy #{policyName} does not exist")
          policyFns.push policies[policyName]
        return policyFns

      # Add policies for specific actions only first
      do ->
        for action, policyNamesToApply of actions
          if action != "*"
            # Check if controller action exists
            if !policiesAndControllers[controller][action]
              throw Error("config.policies: Controller action #{controller}.#{action} does not exist")

            policyFns = makePolicyArray(policyNamesToApply)
            addPolicies(policiesAndControllers[controller], action, policyFns)

      # Add policies to * actions if specified. This must be done last
      do ->
        for action, policyNamesToApply of actions
          if action == "*"
            policyFns = makePolicyArray(policyNamesToApply)
            addDefaultPolicies(policiesAndControllers[controller], policyFns)

  return policiesAndControllers
