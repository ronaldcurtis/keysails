keystone = require('keystone')
Types = keystone.Field.Types
module.exports = 
	options:
		defaultColumns: 'name, email, isAdmin'

	attributes:
	  name:
	    type: Types.Name
	    required: true
	    index: true
	  email:
	    type: Types.Email
	    initial: true
	    required: true
	    index: true
	  password:
	    type: Types.Password
	    initial: true
	    required: true

	special:
		'Permissions':
		  isAdmin:
		    type: Boolean
		    label: 'Can access Keystone'
		    index: true

	virtuals:
		'canAccessKeystone':
			get: () ->
				return this.isAdmin

  relationships:
  	Post: path: 'author'