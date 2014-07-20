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

		it "should add rest routes for that Model", ->
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
















