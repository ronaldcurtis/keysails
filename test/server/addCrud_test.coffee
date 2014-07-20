addCrud = require "../../server/addCrud"
describe "addCrud:", ->

	describe "When config.rest.enabled is true:", ->
		config = 
			rest:
				enabled: true
				returnCrud: () ->
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
















