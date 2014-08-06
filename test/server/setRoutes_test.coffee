setRoutes = require('../../server/setRoutes')
sinon = require('sinon')

describe "setRoutes:", ->

	describe "When no routes have been set:", ->
		app =
			get: sinon.spy()
			put: sinon.spy()
			post: sinon.spy()
			delete: sinon.spy()
		data = 
			app: app
			config:
				routes: {}
			policiesAndControllers: {}

		it "should not throw an error",  ->
			expect(setRoutes).withArgs(data).to.not.throwError()

		it "should not set any routes",  ->
			setRoutes(data)
			expect(app.get.called).to.be(false)
			expect(app.post.called).to.be(false)
			expect(app.put.called).to.be(false)
			expect(app.delete.called).to.be(false)

	describe "When routes have been set", ->

		it "should be able to set get, post, put, and delete routes", ->
			data = 
				app:
					get: sinon.spy()
					post: sinon.spy()
					put: sinon.spy()
					delete: sinon.spy()
				config:
					routes:
						"get /getPath": "PageController.action1"
						"put /putPath": "PageController.action2"
						"post /postPath": "PageController.action3"
						"delete /deletePath": "PageController.action4"
				policiesAndControllers:
					PageController:
						action1: [() ->]
						action2: [() ->]
						action3: [() ->]
						action4: [() ->]

			setRoutes(data)
			expect(data.app.get.called)
			expect(data.app.get.args[0][0]).to.be('/getpath')
			expect(data.app.get.args[0][1]).to.be(data.policiesAndControllers.PageController.action1)
			expect(data.app.put.called)
			expect(data.app.put.args[0][0]).to.be('/putpath')
			expect(data.app.put.args[0][1]).to.be(data.policiesAndControllers.PageController.action2)
			expect(data.app.post.called)
			expect(data.app.post.args[0][0]).to.be('/postpath')
			expect(data.app.post.args[0][1]).to.be(data.policiesAndControllers.PageController.action3)
			expect(data.app.delete.called)
			expect(data.app.delete.args[0][0]).to.be('/deletepath')
			expect(data.app.delete.args[0][1]).to.be(data.policiesAndControllers.PageController.action4)

		it "should normalize route verb and path so they are lowercase", ->
			data = 
				app:
					get: sinon.spy()
				config:
					routes:
						"GET /GETPATH": "PageController.action1"
				policiesAndControllers:
					PageController:
						action1: [() ->]

			setRoutes(data)
			expect(data.app.get.called)
			expect(data.app.get.args[0][0]).to.be('/getpath')
			expect(data.app.get.args[0][1]).to.be(data.policiesAndControllers.PageController.action1)

		it "should throw an error if controller is not defined", ->
			data = 
				app: {}
				config:
					routes:
						"get /": "PageController.action1"
				policiesAndControllers: {}

			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController does not exist')

		it "should throw an error if controller action is not defined", ->

			data = 
				app: {}
				config:
					routes:
						"get /": "PageController.action1"
				policiesAndControllers:
					PageController:
						action2: ->

			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.action1 does not exist')

		it "should throw an error if route is not a string", ->

			data = 
				app: {}
				config:
					routes:
						"get /": []
				policiesAndControllers:
					PageController:
						action2: ->

			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('should be a string')

	describe "When static routes have been set", ->

		it "should create static controller for each route", ->

			render = sinon.spy()

			data = 
				app:
					all: sinon.spy()
				keystone:
					View: sinon.stub().returns({render: render})
				config:
					routes:
						staticRoutes:
							"/": "index"
							"/page": "page"
				policiesAndControllers: {}

			req = sinon.spy()
			res =
				render: sinon.spy()

			setRoutes(data)
			expect(data.app.all.called)
			expect(data.app.all.args[0][0]).to.be('/')
			expect(data.app.all.args[0][1]).to.be.a('function')
			staticController = data.app.all.args[0][1]
			staticController(req,res)
			expect(render.called).to.be(true)
			expect(render.args[0][0]).to.be("index")

			expect(data.app.all.args[1][0]).to.be('/page')
			expect(data.app.all.args[1][1]).to.be.a('function')
			staticController = data.app.all.args[1][1]
			staticController(req,res)
			expect(render.called).to.be(true)
			expect(render.args[1][0]).to.be("page")


		it "should throw error if staticRoutes is not an object", ->

			data = 
				app:
					all: sinon.spy()
				config:
					routes:
						staticRoutes: ->
				policiesAndControllers: {}

			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('should be an object')

		it "should throw error if a staticRoute definition is not a string", ->

			data = 
				app:
					all: sinon.spy()
				config:
					routes:
						staticRoutes:
							"/": ->
				policiesAndControllers: {}

			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('should be a string')


















