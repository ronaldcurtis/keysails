setResponses = require('../../server/setResponses')
sinon = require('sinon')

describe "setResponses:", ->

	describe "When No Models have been set:", ->

		data =
			responses: {}
			app:
				use: sinon.spy()

		it "should not throw an error", ->
			expect(setResponses).withArgs(data).to.not.throwError()

	describe "req.wantsJSON method:", ->

		it "should add wantsJSON method to res", ->
			app =
				use: sinon.spy()
			data = 
				responses: {}
				app: app
			res = 
			req =
				get: sinon.stub().returns('json')
				xhr: true
				is: sinon.spy()
			next = sinon.spy()

			setResponses(data)
			addResponses = data.app.use.args[0][0]
			expect(addResponses).to.be.a('function')
			addResponses(req,res,next)
			expect(req).to.have.property('wantsJSON')
			expect(res.res).to.be(res)
			expect(res.req).to.be(req)
			expect(req.res).to.be(res)
			expect(req.req).to.be(req)

		it "should return true is res.xhr is true", ->
				app =
					use: sinon.spy()
				data = 
					responses: {}
					app: app
				res = {}
				req =
					get: sinon.stub().returns('json')
					xhr: true
					is: sinon.spy()
				next = sinon.spy()

				setResponses(data)
				addResponses = data.app.use.args[0][0]
				addResponses(req,res,next)
				expect(req).to.have.property('wantsJSON')
				expect(req.wantsJSON).to.be(true)

		it "should be true if req is json, and accept header set", ->
				app =
					use: sinon.spy()
				data = 
					responses: {}
					app: app
				res = {}
				req =
					get: sinon.stub().returns('json')
					xhr: false
					is: sinon.stub().returns(true)
				next = sinon.spy()

				setResponses(data)
				addResponses = data.app.use.args[0][0]
				addResponses(req,res,next)
				expect(req).to.have.property('wantsJSON')
				expect(req.wantsJSON).to.be(true)

		it "should be true if req does not specifically ask for html", ->
				app =
					use: sinon.spy()
				data = 
					responses: {}
					app: app
				res = {}
				req =
					get: sinon.stub().returns(undefined)
					xhr: false
					is: sinon.stub().returns(false)
				next = sinon.spy()

				setResponses(data)
				addResponses = data.app.use.args[0][0]
				addResponses(req,res,next)
				expect(req).to.have.property('wantsJSON')
				expect(req.wantsJSON).to.be(true)

		it "should be false only when req is not xhr, wantsHTML, and req is not json", ->
				app =
					use: sinon.spy()
				data = 
					responses: {}
					app: app
				res = {}
				req =
					get: sinon.stub().returns('html')
					xhr: false
					is: sinon.stub().returns(false)
				next = sinon.spy()

				setResponses(data)
				addResponses = data.app.use.args[0][0]
				addResponses(req,res,next)
				expect(req).to.have.property('wantsJSON')
				expect(req.wantsJSON).to.be(false)

	describe "When responses have been defined:", ->

		it "should add response methods to res", ->
				app =
					use: sinon.spy()
				data = 
					responses:
						responseOne: () ->
							return this
						responseTwo: () ->
							return this
					app: app
				res = {}
				req =
					get: sinon.stub().returns('html')
					xhr: false
					is: sinon.stub().returns(false)
				next = sinon.spy()

				setResponses(data)
				addResponses = data.app.use.args[0][0]
				addResponses(req,res,next)
				expect(res.responseOne).to.be(data.responses.responseOne)
				expect(res.responseTwo).to.be(data.responses.responseTwo)
				expect(res.responseOne()).to.be(res)
				expect(res.responseTwo()).to.be(res)
				expect(res.responseOne().req).to.be(req)
				expect(res.responseOne().req).to.have.property('wantsJSON')

		it "should throw an error if response is not a function", ->
				app =
					use: sinon.spy()
				data = 
					responses:
						responseOne: 'yo'
						responseTwo: () ->
							return this
					app: app
				res = {}
				req =
					get: sinon.stub().returns('html')
					xhr: false
					is: sinon.stub().returns(false)
				next = sinon.spy()

				setResponses(data)
				addResponses = data.app.use.args[0][0]
				expect(addResponses).withArgs(req,res,next).to.throwError (e) ->
					expect(e.message).to.contain('should return a function')
				
















