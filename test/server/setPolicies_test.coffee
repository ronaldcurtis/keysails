setPolicies = require('../../server/setPolicies')
sinon = require('sinon')
describe "setPolicies:", ->

	describe "When no policies are configured:", ->

		data =
			config: policies: {}
			policies: {}
			controllers: PageController: showPage: () -> return 'Hello world'

		it "should not throw an error if no policies are configured", ->
			
			expect(setPolicies).withArgs(data).to.not.throwError()

		it "should put any controller methods that are not in an array, into an array", ->
			
			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.showPage).to.be.an('array')
			expect(returnedObj.PageController.showPage[0]()).to.be('Hello world')


	describe "When config.policies is incorrectly defined:", ->

		it "should throw an error if config.policies refers to a policy that does not exist", ->

			data =
				config: policies: PageController: showPage: 'somePolicy'
				policies: {}
				controllers: PageController: showPage: () -> return 'Hello world'

			expect(setPolicies).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('somePolicy does not exist')


		it "should throw an error if config.policies refers to a controller that does not exist", ->

			data =
				config: policies: UserController: someAction: 'somePolicy'
				policies: somePolicy: () ->
				controllers: PageController: showPage: () -> return 'Hello world'

			expect(setPolicies).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('UserController does not exist')


		it "should throw an error if config.policies refers to a controller action that does not exist", ->

			data =
				config: policies: PageController: someAction: 'somePolicy'
				policies: somePolicy: () ->
				controllers: PageController: showPage: () -> return 'Hello world'

			expect(setPolicies).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('someAction does not exist')

	describe "When policies is incorrectly defined:", ->

		it "should throw an error if a defined policy is not a function", ->

			data =
				config: policies: PageController: showPage: 'somePolicy'
				policies: somePolicy: 5
				controllers: PageController: showPage: () -> return 'Hello world'

			expect(setPolicies).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('somePolicy should export a function')

	describe "When controllers is incorrectly defined:", ->

		it "should throw an error if a controller is not an object", ->

			data =
				config: {}
				policies: {}
				controllers: PageController: []

			expect(setPolicies).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController should export an object')

		it "should throw an error if a controller action is not an object", ->

			data =
				config: {}
				policies: {}
				controllers: PageController: someAction: 'hello'

			expect(setPolicies).withArgs(data).to.throwError (e) ->
				expect(e.message).to.contain('PageController.someAction should be a function')

	describe "When adding policies to controllers:", ->

		it "should add specified policies in front of a controller action", ->

			data =
				config:
					policies:
						PageController:
							someAction: 'somePolicy', anotherAction: 'anotherPolicy'
				policies:
					somePolicy: () -> return 'somePolicy here!'
					anotherPolicy: () -> return 'anotherPolicy here!'
				controllers:
					PageController:
						someAction: () -> return 'someAction here!'
						anotherAction: () -> return 'anotherAction here!'

			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.someAction).to.be.an('array')
			expect(returnedObj.PageController.someAction.length).to.be(2)
			expect(returnedObj.PageController.someAction[0]()).to.be('somePolicy here!')
			expect(returnedObj.PageController.someAction[1]()).to.be('someAction here!')
			expect(returnedObj.PageController.anotherAction).to.be.an('array')
			expect(returnedObj.PageController.anotherAction.length).to.be(2)
			expect(returnedObj.PageController.anotherAction[0]()).to.be('anotherPolicy here!')
			expect(returnedObj.PageController.anotherAction[1]()).to.be('anotherAction here!')

		it "should add an array of policies in front of a specified controller action", ->
			data =
				config:
					policies:
						PageController:
							someAction: ['somePolicy', 'anotherPolicy']
				policies:
					somePolicy: () -> return 'somePolicy here!'
					anotherPolicy: () -> return 'anotherPolicy here!'
				controllers:
					PageController:
						someAction: () -> return 'someAction here!'

			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.someAction).to.be.an('array')
			expect(returnedObj.PageController.someAction.length).to.be(3)
			expect(returnedObj.PageController.someAction[0]()).to.be('somePolicy here!')
			expect(returnedObj.PageController.someAction[1]()).to.be('anotherPolicy here!')
			expect(returnedObj.PageController.someAction[2]()).to.be('someAction here!')

		it "should add a default policy only to actions without a policy", ->
			data =
				config:
					policies:
						PageController:
							'*': 'firstPolicy'
							secondAction: 'secondPolicy'
							thirdAction: ['thirdPolicy', 'secondPolicy']
				policies:
					firstPolicy: () -> return 'firstPolicy here!'
					secondPolicy: () -> return 'secondPolicy here!'
					thirdPolicy: () -> return 'thirdPolicy here!'
				controllers:
					PageController:
						firstAction: () -> return 'firstAction here!'
						secondAction: () -> return 'secondAction here!'
						thirdAction: () -> return 'thirdAction here!'

			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.firstAction).to.be.an('array')
			expect(returnedObj.PageController.firstAction.length).to.be(2)
			expect(returnedObj.PageController.firstAction[0]()).to.be('firstPolicy here!')
			expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

			expect(returnedObj.PageController.secondAction).to.be.an('array')
			expect(returnedObj.PageController.secondAction.length).to.be(2)
			expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
			expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

			expect(returnedObj.PageController.thirdAction).to.be.an('array')
			expect(returnedObj.PageController.thirdAction.length).to.be(3)
			expect(returnedObj.PageController.thirdAction[0]()).to.be('thirdPolicy here!')
			expect(returnedObj.PageController.thirdAction[1]()).to.be('secondPolicy here!')
			expect(returnedObj.PageController.thirdAction[2]()).to.be('thirdAction here!')

		it "should add a an array of default policies only to actions without a policy", ->
			data =
				config:
					policies:
						PageController:
							'*': ['firstPolicy', 'secondPolicy']
							secondAction: 'secondPolicy'
							thirdAction: ['thirdPolicy', 'fourthPolicy']
				policies:
					firstPolicy: () -> return 'firstPolicy here!'
					secondPolicy: () -> return 'secondPolicy here!'
					thirdPolicy: () -> return 'thirdPolicy here!'
					fourthPolicy: () -> return 'fourthPolicy here!'
				controllers:
					PageController:
						firstAction: () -> return 'firstAction here!'
						secondAction: () -> return 'secondAction here!'
						thirdAction: () -> return 'thirdAction here!'

			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.firstAction).to.be.an('array')
			expect(returnedObj.PageController.firstAction.length).to.be(3)
			expect(returnedObj.PageController.firstAction[0]()).to.be('firstPolicy here!')
			expect(returnedObj.PageController.firstAction[1]()).to.be('secondPolicy here!')
			expect(returnedObj.PageController.firstAction[2]()).to.be('firstAction here!')

			expect(returnedObj.PageController.secondAction).to.be.an('array')
			expect(returnedObj.PageController.secondAction.length).to.be(2)
			expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
			expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

			expect(returnedObj.PageController.thirdAction).to.be.an('array')
			expect(returnedObj.PageController.thirdAction.length).to.be(3)
			expect(returnedObj.PageController.thirdAction[0]()).to.be('thirdPolicy here!')
			expect(returnedObj.PageController.thirdAction[1]()).to.be('fourthPolicy here!')
			expect(returnedObj.PageController.thirdAction[2]()).to.be('thirdAction here!')

	describe "When adding global policies:", ->

		it "should add default policy only to actions without a policy", ->
			data =
				config:
					policies:
						"*": "firstPolicy"
						PageController:
							'*': 'thirdPolicy'
							secondAction: 'secondPolicy'
				policies:
					firstPolicy: () -> return 'firstPolicy here!'
					secondPolicy: () -> return 'secondPolicy here!'
					thirdPolicy: () -> return 'thirdPolicy here!'
				controllers:
					PageController:
						firstAction: () -> return 'firstAction here!'
						secondAction: () -> return 'secondAction here!'
						thirdAction: () -> return 'thirdAction here!'
					PostController:
						firstAction: () -> return 'postController firstAction here'
						secondAction: () -> return 'postController secondAction here'

			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.firstAction).to.be.an('array')
			expect(returnedObj.PageController.firstAction.length).to.be(2)
			expect(returnedObj.PageController.firstAction[0]()).to.be('thirdPolicy here!')
			expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

			expect(returnedObj.PageController.secondAction).to.be.an('array')
			expect(returnedObj.PageController.secondAction.length).to.be(2)
			expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
			expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

			expect(returnedObj.PageController.thirdAction).to.be.an('array')
			expect(returnedObj.PageController.thirdAction.length).to.be(2)
			expect(returnedObj.PageController.thirdAction[0]()).to.be('thirdPolicy here!')
			expect(returnedObj.PageController.thirdAction[1]()).to.be('thirdAction here!')

			expect(returnedObj.PostController.firstAction).to.be.an('array')
			expect(returnedObj.PostController.firstAction.length).to.be(2)
			expect(returnedObj.PostController.firstAction[0]()).to.be('firstPolicy here!')
			expect(returnedObj.PostController.firstAction[1]()).to.be('postController firstAction here')

			expect(returnedObj.PostController.secondAction).to.be.an('array')
			expect(returnedObj.PostController.secondAction.length).to.be(2)
			expect(returnedObj.PostController.secondAction[0]()).to.be('firstPolicy here!')
			expect(returnedObj.PostController.secondAction[1]()).to.be('postController secondAction here')

		it "should add default policy array only to actions without a policy", ->
			data =
				config:
					policies:
						"*": ["firstPolicy", "thirdPolicy"]
						PageController:
							'*': 'thirdPolicy'
							secondAction: 'secondPolicy'
				policies:
					firstPolicy: () -> return 'firstPolicy here!'
					secondPolicy: () -> return 'secondPolicy here!'
					thirdPolicy: () -> return 'thirdPolicy here!'
				controllers:
					PageController:
						firstAction: () -> return 'firstAction here!'
						secondAction: () -> return 'secondAction here!'
						thirdAction: () -> return 'thirdAction here!'
					PostController:
						firstAction: () -> return 'postController firstAction here'
						secondAction: () -> return 'postController secondAction here'

			returnedObj = setPolicies(data)
			expect(returnedObj.PageController.firstAction).to.be.an('array')
			expect(returnedObj.PageController.firstAction.length).to.be(2)
			expect(returnedObj.PageController.firstAction[0]()).to.be('thirdPolicy here!')
			expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

			expect(returnedObj.PageController.secondAction).to.be.an('array')
			expect(returnedObj.PageController.secondAction.length).to.be(2)
			expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
			expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

			expect(returnedObj.PageController.thirdAction).to.be.an('array')
			expect(returnedObj.PageController.thirdAction.length).to.be(2)
			expect(returnedObj.PageController.thirdAction[0]()).to.be('thirdPolicy here!')
			expect(returnedObj.PageController.thirdAction[1]()).to.be('thirdAction here!')

			expect(returnedObj.PostController.firstAction).to.be.an('array')
			expect(returnedObj.PostController.firstAction.length).to.be(3)
			expect(returnedObj.PostController.firstAction[0]()).to.be('firstPolicy here!')
			expect(returnedObj.PostController.firstAction[1]()).to.be('thirdPolicy here!')
			expect(returnedObj.PostController.firstAction[2]()).to.be('postController firstAction here')

			expect(returnedObj.PostController.secondAction).to.be.an('array')
			expect(returnedObj.PostController.secondAction.length).to.be(3)
			expect(returnedObj.PostController.secondAction[0]()).to.be('firstPolicy here!')
			expect(returnedObj.PostController.secondAction[1]()).to.be('thirdPolicy here!')
			expect(returnedObj.PostController.secondAction[2]()).to.be('postController secondAction here')


		describe "When * is a boolean in policy config:", ->

			it "should add true policy as global default if if * is true for all controllers", ->
				data =
					config:
						policies:
							"*": true
							PageController:
								'*': 'thirdPolicy'
								secondAction: 'secondPolicy'
					policies:
						firstPolicy: () -> return 'firstPolicy here!'
						secondPolicy: () -> return 'secondPolicy here!'
						thirdPolicy: () -> return 'thirdPolicy here!'
					controllers:
						PageController:
							firstAction: () -> return 'firstAction here!'
							secondAction: () -> return 'secondAction here!'
							thirdAction: () -> return 'thirdAction here!'
						PostController:
							firstAction: () -> return 'postController firstAction here'
							secondAction: () -> return 'postController secondAction here'

				returnedObj = setPolicies(data)
				expect(returnedObj.PageController.firstAction).to.be.an('array')
				expect(returnedObj.PageController.firstAction.length).to.be(2)
				expect(returnedObj.PageController.firstAction[0]()).to.be('thirdPolicy here!')
				expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

				expect(returnedObj.PageController.secondAction).to.be.an('array')
				expect(returnedObj.PageController.secondAction.length).to.be(2)
				expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
				expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

				expect(returnedObj.PageController.thirdAction).to.be.an('array')
				expect(returnedObj.PageController.thirdAction.length).to.be(2)
				expect(returnedObj.PageController.thirdAction[0]()).to.be('thirdPolicy here!')
				expect(returnedObj.PageController.thirdAction[1]()).to.be('thirdAction here!')

				expect(returnedObj.PostController.firstAction).to.be.an('array')
				expect(returnedObj.PostController.firstAction.length).to.be(2)
				truePolicy = returnedObj.PostController.firstAction[0]
				req = sinon.spy()
				res = sinon.spy()
				next = sinon.spy()
				truePolicy(req,res,next)
				expect(res.called).to.be(false)
				expect(next.called).to.be(true)
				expect(next.args[0].length).to.be(0)
				expect(returnedObj.PostController.firstAction[1]()).to.be('postController firstAction here')

				expect(returnedObj.PostController.secondAction).to.be.an('array')
				expect(returnedObj.PostController.secondAction.length).to.be(2)
				truePolicy = returnedObj.PostController.secondAction[0]
				req = sinon.spy()
				res = sinon.spy()
				next = sinon.spy()
				truePolicy(req,res,next)
				expect(res.called).to.be(false)
				expect(next.called).to.be(true)
				expect(next.args[0].length).to.be(0)
				expect(returnedObj.PostController.secondAction[1]()).to.be('postController secondAction here')


			it "should add true policy as controller default if * is true for a specific controller", ->
				data =
					config:
						policies:
							PageController:
								'*': true
								secondAction: 'secondPolicy'
					policies:
						firstPolicy: () -> return 'firstPolicy here!'
						secondPolicy: () -> return 'secondPolicy here!'
						thirdPolicy: () -> return 'thirdPolicy here!'
					controllers:
						PageController:
							firstAction: () -> return 'firstAction here!'
							secondAction: () -> return 'secondAction here!'
							thirdAction: () -> return 'thirdAction here!'

				returnedObj = setPolicies(data)
				expect(returnedObj.PageController.firstAction).to.be.an('array')
				expect(returnedObj.PageController.firstAction.length).to.be(2)
				truePolicy = returnedObj.PageController.firstAction[0]
				req = sinon.spy()
				res = sinon.spy()
				next = sinon.spy()
				truePolicy(req,res,next)
				expect(res.called).to.be(false)
				expect(next.called).to.be(true)
				expect(next.args[0].length).to.be(0)
				expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

				expect(returnedObj.PageController.secondAction).to.be.an('array')
				expect(returnedObj.PageController.secondAction.length).to.be(2)
				expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
				expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

				expect(returnedObj.PageController.thirdAction).to.be.an('array')
				expect(returnedObj.PageController.thirdAction.length).to.be(2)
				truePolicy = returnedObj.PageController.thirdAction[0]
				req = sinon.spy()
				res = sinon.spy()
				next = sinon.spy()
				truePolicy(req,res,next)
				expect(res.called).to.be(false)
				expect(next.called).to.be(true)
				expect(next.args[0].length).to.be(0)
				expect(returnedObj.PageController.thirdAction[1]()).to.be('thirdAction here!')

			it "should add false policy as global default if if * is false for all controllers", ->
				data =
					config:
						policies:
							"*": false
							PageController:
								'*': 'thirdPolicy'
								secondAction: 'secondPolicy'
					policies:
						firstPolicy: () -> return 'firstPolicy here!'
						secondPolicy: () -> return 'secondPolicy here!'
						thirdPolicy: () -> return 'thirdPolicy here!'
					controllers:
						PageController:
							firstAction: () -> return 'firstAction here!'
							secondAction: () -> return 'secondAction here!'
							thirdAction: () -> return 'thirdAction here!'
						PostController:
							firstAction: () -> return 'postController firstAction here'
							secondAction: () -> return 'postController secondAction here'

				returnedObj = setPolicies(data)
				expect(returnedObj.PageController.firstAction).to.be.an('array')
				expect(returnedObj.PageController.firstAction.length).to.be(2)
				expect(returnedObj.PageController.firstAction[0]()).to.be('thirdPolicy here!')
				expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

				expect(returnedObj.PageController.secondAction).to.be.an('array')
				expect(returnedObj.PageController.secondAction.length).to.be(2)
				expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
				expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

				expect(returnedObj.PageController.thirdAction).to.be.an('array')
				expect(returnedObj.PageController.thirdAction.length).to.be(2)
				expect(returnedObj.PageController.thirdAction[0]()).to.be('thirdPolicy here!')
				expect(returnedObj.PageController.thirdAction[1]()).to.be('thirdAction here!')

				expect(returnedObj.PostController.firstAction).to.be.an('array')
				expect(returnedObj.PostController.firstAction.length).to.be(2)
				falsePolicy = returnedObj.PostController.firstAction[0]
				req = sinon.spy()
				res =
					notFound: sinon.spy()
				next = sinon.spy()
				falsePolicy(req,res,next)
				expect(req.called).to.be(false)
				expect(res.notFound.called).to.be(true)
				expect(next.called).to.be(false)
				expect(returnedObj.PostController.firstAction[1]()).to.be('postController firstAction here')

				expect(returnedObj.PostController.secondAction).to.be.an('array')
				expect(returnedObj.PostController.secondAction.length).to.be(2)
				falsePolicy = returnedObj.PostController.secondAction[0]
				req = sinon.spy()
				res =
					notFound: sinon.spy()
				next = sinon.spy()
				falsePolicy(req,res,next)
				expect(req.called).to.be(false)
				expect(res.notFound.called).to.be(true)
				expect(next.called).to.be(false)
				expect(returnedObj.PostController.secondAction[1]()).to.be('postController secondAction here')

			it "should add false policy as controller default if * is false for a specific controller", ->
				data =
					config:
						policies:
							PageController:
								'*': false
								secondAction: 'secondPolicy'
					policies:
						firstPolicy: () -> return 'firstPolicy here!'
						secondPolicy: () -> return 'secondPolicy here!'
						thirdPolicy: () -> return 'thirdPolicy here!'
					controllers:
						PageController:
							firstAction: () -> return 'firstAction here!'
							secondAction: () -> return 'secondAction here!'
							thirdAction: () -> return 'thirdAction here!'

				returnedObj = setPolicies(data)
				expect(returnedObj.PageController.firstAction).to.be.an('array')
				expect(returnedObj.PageController.firstAction.length).to.be(2)
				falsePolicy = returnedObj.PageController.firstAction[0]
				req = sinon.spy()
				res =
					notFound: sinon.spy()
				next = sinon.spy()
				falsePolicy(req,res,next)
				expect(req.called).to.be(false)
				expect(res.notFound.called).to.be(true)
				expect(next.called).to.be(false)
				expect(returnedObj.PageController.firstAction[1]()).to.be('firstAction here!')

				expect(returnedObj.PageController.secondAction).to.be.an('array')
				expect(returnedObj.PageController.secondAction.length).to.be(2)
				expect(returnedObj.PageController.secondAction[0]()).to.be('secondPolicy here!')
				expect(returnedObj.PageController.secondAction[1]()).to.be('secondAction here!')

				expect(returnedObj.PageController.thirdAction).to.be.an('array')
				expect(returnedObj.PageController.thirdAction.length).to.be(2)
				falsePolicy = returnedObj.PageController.thirdAction[0]
				req = sinon.spy()
				res =
					notFound: sinon.spy()
				next = sinon.spy()
				falsePolicy(req,res,next)
				expect(req.called).to.be(false)
				expect(res.notFound.called).to.be(true)
				expect(next.called).to.be(false)
				expect(returnedObj.PageController.thirdAction[1]()).to.be('thirdAction here!')










