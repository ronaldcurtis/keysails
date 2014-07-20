_ = require('underscore')
keystone = require('keystone')
app = keystone.app
express = keystone.express
path = require('path')

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

# Initialize asset pipeline first
mincer = require('./assets')
app.use(mincer.assets())

# Connect-mincer serves our assets in dev
# We must precompile our assets before starting in production
if (process.env.NODE_ENV != 'production')
	app.use('/assets', mincer.createServer())
else
	app.use('/assets', express.static(path.join(__dirname, "../.built")))

module.exports = 
	preRoutes: [initLocals]
	preRender: [flashMessages]