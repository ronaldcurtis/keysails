setPolicies = require('../../server/setPolicies')
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

	describe "When adding policies to controllers", ->

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














