# Config for automatic REST routes
getModelName = (req) ->
  return req.params.model.charAt(0).toUpperCase() + req.params.model.slice(1).toLowerCase()

module.exports =
  enabled: true
  prefix: '/api/v1'

  methods:
    create: (req, res) ->
      model = getModelName(req)
      res.send {msg: "create method triggered!" }

    read: (req, res) ->
      model = getModelName(req)
      res.send {msg: "read method triggered!" }

    update: (req,res) ->
      model = getModelName(req)
      res.send {msg: "update method triggered!" }

    delete: (req,res) ->
      model = getModelName(req)
      res.send {msg: "delete method triggered!" }
