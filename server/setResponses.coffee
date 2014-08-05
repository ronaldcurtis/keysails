module.exports = (data) ->
	includeAll = require('include-all')
	typeCheck  = require('type-check').typeCheck
	responses  = data.responses
	app        = data.app

	addResponses = (req,res,next) ->
		###*
		 * Assume a request wants json response if:
		 * • this request is an ajax request
		 * • this request does not explicitly want html
		 * • this request has a 'json' content-type, and its accept header is set
		 * 
		###
		accept = req.get('Accept')
		wantsHTML = do ->
			if accept
				return (accept.indexOf('html') != -1)
			else
				return false
		req.wantsJSON = req.xhr
		req.wantsJSON = req.wantsJSON || !wantsHTML
		req.wantsJSON = req.wantsJSON || ( req.is('json') && !!accept )

		###*
		 * Attach both req and res to each other
		###
		req.res = res
		req.req = req
		res.res = res
		res.req = req

		# Set Response methods
		for responseName, responseFn of responses
			if !typeCheck('Function', responseFn)
				throw new Error "api/#{responseName} should return a function"
			res[responseName] = responseFn

		next()

	app.use(addResponses)



