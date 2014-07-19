# Config for automatic REST routes
keystone = require('keystone')

module.exports =
  enabled: true
  prefix: '/api/v1'

  returnCrud: (modelName) ->
    crudMethods =
      create: (req, res) ->
        res.json {msg: "create method triggered!" }

      read: (req, res) ->
        res.json {msg: "read method triggered!"}

      update: (req,res) ->
        res.json {msg: "update method triggered!" }

      delete: (req,res) ->
        res.json {msg: "delete method triggered!"}

    return crudMethods
