module.exports = (modelBlueprints) ->
	keystone = require('keystone')
	_        = require('underscore')
	check    = require('check-types')

	for modelName, blueprint of modelBlueprints

		Model = new keystone.List(modelName, blueprint.options)

		# Add Attributes
		if blueprint.attributes
			do ->
				attrsArray = [blueprint.attributes]
				if blueprint.special
					for specialTitle, specialAttrs of blueprint.special
						attrsArray.push(specialTitle)
						attrsArray.push(specialAttrs)
				Model.add.apply(Model,attrsArray)

		# Add Virtuals
		if blueprint.virtuals
			do ->
				for virtualName,fns of blueprint.virtuals
					if fns.get
						Model.schema.virtual(virtualName).get(fns.get)
					if fns.set
						Model.schema.virtual(virtualName).set(fns.set)

		# Add Relationships
		if blueprint.relationships
			do ->
				for ref,config of blueprint.relationships
					config = _.extend({ref: ref}, config)
					Model.relationship(config)

		# Add Validations
		if blueprint.validate
	    do ->
	      addValidation = (attr,validation) ->
	        Model.schema.path(attr).validate(validation.fn, validation.msg)

        for attr, validation of blueprint.validate
          if check.object(validation)
          	addValidation(attr,validation)

          else if check.array(validation)
            for obj,i in validation
              addValidation(attr,obj)
		
		# Register Model
		Model.register()



