module.exports =
  showHome: (req,res) ->
    locals = res.locals
    view = new keystone.View(req, res)
    locals.section = 'home'
    view.render('index')