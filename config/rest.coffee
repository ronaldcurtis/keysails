# Config for automatic REST routes
keystone = require('keystone')

module.exports =
  enabled: false
  prefix: '/api/v1'

  crud: (modelName) ->
    crudMethods =
      create: (req, res) ->
        Model = keystone.list(modelName)
        newDoc = new Model.model(req.body)
        newDoc.save (err,doc) ->
          if err
            return res.json(500, 'Server Error (500)')
          else
            res.json(200, doc)

      read: (req, res) ->
        if req.params.id
          keystone.list(modelName).model.findById(req.params.id).exec (err,doc) ->
            if err
              return res.json(500, 'Server Error (500)')
            else
              res.json(200, doc)
        else
          keystone.list(modelName).model.find().exec (err,docs) ->
            if err
              return res.json(500, 'Server Error (500)')
            else
              res.json(200, docs)

      update: (req,res) ->
        keystone.list(modelName).model.findById(req.params.id).exec (err,doc) ->
          if err
            return res.json(500, 'Server Error (500)')
          if doc
            for key,value of req.body
              doc[key] = value
            doc.save (err, doc) ->
              if err
                return res.json(500, 'Server Error (500)')
              else
                res.json(200, doc)

      delete: (req,res) ->
        keystone.list(modelName).model.findById(req.params.id).remove (err) ->
          if err
            return res.json(500, 'Server Error (500)')
          else
            res.send(200)

    return crudMethods
