module.exports = (data) ->
	middleware = data.config.middleware
	typeCheck = require('type-check').typeCheck
	keystone = require('keystone')

	if middleware.preRoutes
		if !typeCheck('Array', middleware.preRoutes)
			throw Error "config.middleware.preRoutes should be an array"
		for fn in middleware.preRoutes
			keystone.pre('routes', fn)

	if middleware.preRender
		if !typeCheck('Array', middleware.preRender)
			throw Error "config.middleware.preRender should be an array"
		for fn in middleware.preRender
			keystone.pre('render', fn)

