setRestRoutes = require('../../server/setRestRoutes')
sinon = require('sinon')

describe "setRestRoutes:", ->

	describe "When No Models have been set:", ->
		app =
			get: sinon.spy()
			put: sinon.spy()
			post: sinon.spy()
			delete: sinon.spy()
		data = 
			app: app
			config:
				rest: {}
			modelBlueprints: {}
			policiesAndControllers: {}

		it "should not throw an error",  ->
			expect(setRestRoutes).withArgs(data).to.not.throwError()

		it "should not add any routes",  ->
			expect(app.get.called).to.be(false)
			expect(app.post.called).to.be(false)
			expect(app.put.called).to.be(false)
			expect(app.delete.called).to.be(false)


	describe "When a Model exists and rest is enabled:", ->
		app =
			get: sinon.spy()
			put: sinon.spy()
			post: sinon.spy()
			delete: sinon.spy()

		data = 
			app: app
			config:
				rest:
					enabled: true
			modelBlueprints:
				Page: {}
			policiesAndControllers:
				PageController:
					create: () ->
					read: () ->
					update: () ->
					delete: () ->

		it "should add rest routes for that Model with default prefix of /api if no prefix specified", ->
			setRestRoutes(data)
			expect(app.get.called).to.be(true)
			expect(app.post.called).to.be(true)
			expect(app.put.called).to.be(true)
			expect(app.delete.called).to.be(true)

			expect(app.get.args[0][0]).to.be('/api/page/:id?')
			expect(app.get.args[0][1]).to.be(data.policiesAndControllers.PageController.read)
			expect(app.post.args[0][0]).to.be('/api/page')
			expect(app.post.args[0][1]).to.be(data.policiesAndControllers.PageController.create)
			expect(app.put.args[0][0]).to.be('/api/page/:id')
			expect(app.put.args[0][1]).to.be(data.policiesAndControllers.PageController.update)
			expect(app.delete.args[0][0]).to.be('/api/page/:id')
			expect(app.delete.args[0][1]).to.be(data.policiesAndControllers.PageController.delete)

		it "should add rest routes for that Model with configured prefix", ->
			data.config.rest.prefix = '/api/v1'
			setRestRoutes(data)
			expect(app.get.called).to.be(true)
			expect(app.post.called).to.be(true)
			expect(app.put.called).to.be(true)
			expect(app.delete.called).to.be(true)

			expect(app.get.args[1][0]).to.be('/api/v1/page/:id?')
			expect(app.get.args[1][1]).to.be(data.policiesAndControllers.PageController.read)
			expect(app.post.args[1][0]).to.be('/api/v1/page')
			expect(app.post.args[1][1]).to.be(data.policiesAndControllers.PageController.create)
			expect(app.put.args[1][0]).to.be('/api/v1/page/:id')
			expect(app.put.args[1][1]).to.be(data.policiesAndControllers.PageController.update)
			expect(app.delete.args[1][0]).to.be('/api/v1/page/:id')
			expect(app.delete.args[1][1]).to.be(data.policiesAndControllers.PageController.delete)

		it "should throw an error if controller.read does not exist", ->
			delete data.policiesAndControllers.PageController.read
			expect(setRestRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.read does not exist')

		it "should throw an error if controller.create does not exist", ->
			data.policiesAndControllers.PageController.read = () ->
			delete data.policiesAndControllers.PageController.create
			expect(setRestRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.create does not exist')

		it "should throw an error if controller.update does not exist", ->
			data.policiesAndControllers.PageController.create = () ->
			delete data.policiesAndControllers.PageController.update
			expect(setRestRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.update does not exist')

		it "should throw an error if controller.delete does not exist", ->
			data.policiesAndControllers.PageController.update = () ->
			delete data.policiesAndControllers.PageController.delete
			expect(setRestRoutes).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.delete does not exist')
















