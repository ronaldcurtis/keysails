module.exports = (grunt) ->

	grunt.initConfig
		shell:
			precompile:
				command: 'node precompile.js'
				options:
					stdout: true
					failOnError: true

		clean:
			built: ['.built']

		mochaTest:
			test:
				options:
					reporter: 'spec'
					require: [
						'coffee-script/register'
						() ->
							global.expect = require('expect.js')
						() ->
							global.typeCheck = require('type-check').typeCheck
					]
				src: ['test/**/*.coffee']


	# Load plugins
	grunt.loadNpmTasks('grunt-shell')
	grunt.loadNpmTasks('grunt-contrib-clean')
	grunt.loadNpmTasks('grunt-mocha-test')

	# Run server side tests
	grunt.registerTask('test', ['mochaTest'])

	# Run this task before starting in production
	grunt.registerTask('precompile', ['clean','shell:precompile'])