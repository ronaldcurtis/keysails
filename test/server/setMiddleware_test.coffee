setMiddleware = require('../../server/setMiddleware')
sinon = require('sinon')

describe "setMiddleware:", ->

	describe "When no middleare have been set:", ->
		data = 
			config:
				middleware: {}
			keystone:
				pre: sinon.spy()

		it "should not throw an error",  ->
			expect(setMiddleware).withArgs(data).to.not.throwError()

		it "should not attempt to set any middleware",  ->
			expect(data.keystone.pre.called).to.be(false)

	describe "When middleware has been set:", ->

		it "should throw an error if preRoutes middleware is not an array of functions", ->
			data =
				config:
					middleware:
						preRoutes: {}
				keystone: pre: sinon.spy()

			expect(setMiddleware).withArgs(data).to.throwError (e) ->
				expect(e.message).to.be('config.middleware.preRoutes should be an array')

			data.config.middleware.preRoutes = [
				() ->
				{}
			]

			expect(setMiddleware).withArgs(data).to.throwError (e) ->
				expect(e.message).to.be('config.middleware.preRoutes should be an array containing only functions')

		it "should throw an error if preRender middleware is not an array of functions", ->
			data =
				config:
					middleware:
						preRender: {}
				keystone: pre: sinon.spy()

			expect(setMiddleware).withArgs(data).to.throwError (e) ->
				expect(e.message).to.be('config.middleware.preRender should be an array')

			data.config.middleware.preRender = [
				() ->
				{}
			]

			expect(setMiddleware).withArgs(data).to.throwError (e) ->
				expect(e.message).to.be('config.middleware.preRender should be an array containing only functions')

		it "should apply middleware if correctly defined", ->
			data =
				config:
					middleware:
						preRoutes:[
							()-> return 'preRoute1'
							()-> return 'preRoute2'
						]
						preRender:[
							()-> return 'preRender1'
							()-> return 'preRender2'
						]
				keystone: pre: sinon.spy()

			setMiddleware(data)
			expect(data.keystone.pre.args[0][0]).to.be('routes')
			expect(data.keystone.pre.args[0][1]()).to.be('preRoute1')
			expect(data.keystone.pre.args[1][0]).to.be('routes')
			expect(data.keystone.pre.args[1][1]()).to.be('preRoute2')
			expect(data.keystone.pre.args[2][0]).to.be('render')
			expect(data.keystone.pre.args[2][1]()).to.be('preRender1')
			expect(data.keystone.pre.args[3][0]).to.be('render')
			expect(data.keystone.pre.args[3][1]()).to.be('preRender2')










