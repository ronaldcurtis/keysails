keystone = require('keystone')
Types = keystone.Field.Types

module.exports = 
  options:
    map: name: 'title'
    autokey: path: 'slug', from: 'title', unique: true
    defaultColumns: 'title, state|20%, author|20%, publishedDate|20%'

  attributes:
    title:
      type: String
      required: true
    state: 
      type: Types.Select
      options: 'draft, published, archived'
      default: 'draft'
      index: true
    author:
      type: Types.Relationship
      ref: 'User'
      index: true
    publishedDate:
      type: Types.Date
      index: true
      dependsOn:
        state: 'published'
    content:
      brief:
        type: Types.Html
        wysiwyg: true
        height: 150
      extended:
        type: Types.Html
        wysiwyg: true
        height: 400

  virtuals:
    'content.full':
      get: () ->
        return this.content.extended || this.content.brief

  # Instance Methods
  methods:
    methodOne: () ->
      console.log("Page Model: instance method methodOne here")

    methodTwo: () ->
      console.log("Page Model: instance method methodTwo here")

  # Schema methods
  statics:
    staticOne: () ->
      console.log("Page Model: Schema static method staticOne here")
    staticTwo: () ->
      console.log("Page Model: Schema static method staticTwo here")

  # Validations
  validate:
    title:
      [
        {
          fn: (value) ->
            console.log("Title validation 1 running")
            if value.trim().length > 50 then return false
          msg: "Title must be less than 50 characters long"
        }
        {
          fn: (value, done) ->
            console.log("Title validation 2 Async running")
            setTimeout ()->
              if value.trim().length < 3 then done(false) else done(true)
            , 10
          msg: "Title must be more than 2 characters long"
        }
      ]
    state:
      fn: (value) ->
        console.log("state validation Running")
        # if value.indexOf('@') == -1 then return false else return true
        return true
      msg: "State not valid"

  # Lifecycle callbacks
  pre:
    save:
      [
        (next, done) ->
          next()
          setTimeout ()->
            console.log('Async pre save callback here')
            done()
          , 2000
        (next, done) ->
          next()
          setTimeout ()->
            console.log('Async pre save callback here no 2')
            done()
          , 2000
      ]

  post:
    save:
      [
        (doc) ->
          console.log("Post save callback 1 here")
        (doc) ->
          console.log("Post save callback 2 here")
      ]