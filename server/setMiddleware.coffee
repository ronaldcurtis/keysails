module.exports = (data) ->
	middleware = data.config.middleware
	typeCheck = require('type-check').typeCheck
	keystone = require('keystone')

	if middleware.pre && middleware.pre.routes
		if !typeCheck('Array', middleware.pre.routes)
			throw Error "config.middleware.pre.routes should be an array"
		for fn in middleware.pre.routes
			console.log('preroutes fn', fn)
			keystone.pre('routes', fn)

	if middleware.pre && middleware.pre.render
		if !typeCheck('Array', middleware.pre.render)
			throw Error "config.middleware.pre.render should be an array"
		for fn in middleware.pre.render
			keystone.pre('render', fn)

