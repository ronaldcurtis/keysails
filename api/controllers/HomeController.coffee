keystone = require('keystone')
module.exports =
  showHome: (req,res) ->
    view = new keystone.View(req, res)
    res.locals.section = 'home'
    view.render('index')