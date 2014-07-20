_ = require('underscore')

initLocals = (req,res,next) ->
	locals = res.locals
	locals.navLinks = [label: 'Home', key: 'home', href: '/']
	locals.user = req.user
	next()

flashMessages = (req,res,next) ->
	flashMessages =
		info: req.flash('info')
		success: req.flash('success')
		warning: req.flash('warning')
		error: req.flash('error')
	
	if _.any(flashMessages, (msgs) -> return msgs.length)
		res.locals.messages = flashMessages
	else
		res.locals.messages = false
	
	next()


module.exports = 
	preRoutes: [initLocals]
	preRender: [flashMessages]