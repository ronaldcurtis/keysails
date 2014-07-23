module.exports = (data) ->
	middleware = data.config.middleware
	typeCheck = require('type-check').typeCheck
	keystone = data.keystone

	arrayCheck = (type, array) ->
		if !typeCheck('Array', array)
			throw Error "config.middleware.#{type} should be an array"

	fnCheck = (type, fn) ->
		if !typeCheck('Function', fn)
			throw Error "config.middleware.#{type} should be an array containing only functions"

	if middleware.preRoutes
		arrayCheck('preRoutes',middleware.preRoutes)
		for fn in middleware.preRoutes
			fnCheck('preRoutes', fn)
			keystone.pre('routes', fn)

	if middleware.preRender
		arrayCheck('preRender',middleware.preRender)
		for fn in middleware.preRender
			fnCheck('preRender', fn)
			keystone.pre('render', fn)

