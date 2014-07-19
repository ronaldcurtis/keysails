# Config for automatic REST routes

module.exports =
  enabled: true
  prefix: '/api/v1'

  methods:
    create: (req, res) ->
      modelName = getModelName(req)
      res.json {msg: "create method triggered!", modelName: modelName }

    read: (req, res) ->
      modelName = getModelName(req)
      res.json {msg: "read method triggered!", modelName: modelName }

    update: (req,res) ->
      modelName = getModelName(req)
      res.json {msg: "update method triggered!", modelName: modelName }

    delete: (req,res) ->
      modelName = getModelName(req)
      res.json {msg: "delete method triggered!", modelName: modelName }
