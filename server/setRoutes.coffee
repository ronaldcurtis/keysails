
exports = module.exports = (data) ->
  app                    = data.app
  config                 = data.config
  policiesAndControllers = data.policiesAndControllers
  routes                 = config.routes

  for key,value of routes
    keyArray = key.trim().split(' ')
    valueArray = value.trim().split('.')
    verb = keyArray[0]
    path = keyArray[1]
    controller = valueArray[0]
    action = valueArray[1]

    if !policiesAndControllers[controller] then throw Error("config.routes: Controller #{controller} does not exist")
    if !policiesAndControllers[controller][action] then throw Error("config.routes: Controller action #{controller}.#{action} does not exist")

    app[verb](path, policiesAndControllers[controller][action])