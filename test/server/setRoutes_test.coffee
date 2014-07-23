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
		data = 
			app: {}
			config:
				routes:
					"get /": "PageController.action1"
			policiesAndControllers: {}


		it "should throw an error if controller is not defined", ->
			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController does not exist')

		it "should throw an error if controller action is not defined", ->
			data.policiesAndControllers.PageController =
				action2: ->
			expect(setRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.action1 does not exist')

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















