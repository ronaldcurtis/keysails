addCrud = require "../../server/addCrud"
describe "addCrud:", ->

	describe "When config.rest.enabled is true:", ->
		config = 
			rest:
				enabled: true
				crud: () ->
					return {
						create: () ->
							return 'createMethod'
						read: () ->
							return 'readMethod'
						update: () ->
							return 'updateMethod'
						delete: () ->
							return 'deleteMethod'
					}

		it "should create a controller for a model if one does not exist", ->
			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}
			
			addCrud(data)
			expect(data.controllers).to.have.property('PageController')

		it "should create a controller with crud methods specified in config", ->
			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			addCrud(data)
			expect(data.controllers.PageController).to.have.property('create')
			expect(data.controllers.PageController).to.have.property('read')
			expect(data.controllers.PageController).to.have.property('update')
			expect(data.controllers.PageController).to.have.property('delete')
			expect(data.controllers.PageController.create()).to.be('createMethod')
			expect(data.controllers.PageController.read()).to.be('readMethod')
			expect(data.controllers.PageController.update()).to.be('updateMethod')
			expect(data.controllers.PageController.delete()).to.be('deleteMethod')

		it "should not create a controller for a model if rest = false for the model", ->
			data = 
				config: config
				modelBlueprints:
					Page: { rest: false }
				controllers: {}

			addCrud(data)
			expect(data.controllers).to.not.have.property('PageController')

		it "should create a controller for a model if rest = true for the model", ->
			data = 
				config: config
				modelBlueprints:
					Page: { rest: true }
				controllers: {}

			addCrud(data)
			expect(data.controllers).to.have.property('PageController')

		it "should not overwrite any crud methods on an existing controller", ->
			data = 
				config: config
				modelBlueprints:
					Page: { rest: true }
				controllers:
					PageController:
						create: () ->
							return 'imdifferent'
						read: () ->
							return 'soami'

			addCrud(data)
			expect(data.controllers.PageController.create()).to.be('imdifferent')
			expect(data.controllers.PageController.read()).to.be('soami')
			expect(data.controllers.PageController.update()).to.be('updateMethod')
			expect(data.controllers.PageController.delete()).to.be('deleteMethod')

	###*
	* When config.rest.enabled is false
	###
	describe "When config.rest.enabled is false:", ->
		config = 
			rest:
				enabled: false
				crud: () ->
					return {
						create: () ->
							return 'createMethod'
						read: () ->
							return 'readMethod'
						update: () ->
							return 'updateMethod'
						delete: () ->
							return 'deleteMethod'
					}

		it "should not add a controller for a model if it does not exist", ->
			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			addCrud(data)
			expect(data.controllers).to.not.have.property('PageController')

		it "should add a controller for a model if rest = true in the specific model", ->
			data = 
				config: config
				modelBlueprints:
					Page: { rest: true}
				controllers: {}

			addCrud(data)
			expect(data.controllers).to.have.property('PageController')
			expect(data.controllers.PageController.create()).to.be('createMethod')
			expect(data.controllers.PageController.read()).to.be('readMethod')
			expect(data.controllers.PageController.update()).to.be('updateMethod')
			expect(data.controllers.PageController.delete()).to.be('deleteMethod')


	###*
	 * Throwing errors
	###

	describe "Tests for throwing errors:", ->

		it "should throw an error if config.rest.crud is not defined", ->
			config = 
				rest:
					enabled: true
			data = 
				config: config
				modelBlueprints:
					Page: { rest: true}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud does not return an object", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						return []

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()


		it "should throw an error if config.rest.crud does not return an object with a create method", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							read: () ->
							update: () ->
							delete: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud does not return an object with a read method", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: () ->
							update: () ->
							delete: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud does not return an object with an update method", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: () ->
							read: () ->
							delete: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud does not return an object with a delete method", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: () ->
							read: () ->
							update: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()


		it "should throw an error if config.rest.crud create property is not a function", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: 'yo'
							read: () ->
							update: () ->
							delete: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud read property is not a function", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: () ->
							read: ''
							update: () ->
							delete: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud update property is not a function", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: () ->
							read: () ->
							update: []
							delete: () ->

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()

		it "should throw an error if config.rest.crud delete property is not a function", ->
			config = 
				rest:
					enabled: true
					crud: () ->
						obj =
							create: () ->
							read: () ->
							update: () ->
							delete: ''

			data = 
				config: config
				modelBlueprints:
					Page: {}
				controllers: {}

			expect(addCrud).withArgs(data).to.throwError()















