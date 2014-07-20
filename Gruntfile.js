'use strict()';
module.exports = function(grunt) {

  grunt.initConfig({

    // CLI Tasks
    shell: {
      precompile: {
        command: 'node precompile.js',
        options: {
          stdout: true,
          failOnError: true
        }
      }
    },

    // Clean
    clean: {
      temp: ['.built']
    },


    // Set env vars
    env : {
      test : {
        NODE_ENV : 'test',
      }
    },

    // Tests
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: ['coffee-script/register']
        },
        src: ['test/**/*.coffee']
      }
    }
  });

  // Load plugins
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-env');

  // Run server side tests
  grunt.registerTask('test', ['env:test','mochaTest']);

  // Run this task before starting in production
  grunt.registerTask('precompile', [
    'clean',
    'shell:precompile'
  ]);
};