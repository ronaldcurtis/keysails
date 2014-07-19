keystone = require('keystone')
Types = keystone.Field.Types


Page = new keystone.List 'Page',
  map: name: 'title',
  autokey: path: 'slug', from: 'title', unique: true
  defaultColumns: 'title, state|20%, author|20%, publishedDate|20%'

Page.add
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

Page.schema.virtual('content.full').get () ->
  return this.content.extended || this.content.brief

Page.register();
