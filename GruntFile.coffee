fs = require "fs-extra"
mongoose = require "mongoose"

config = require "./configuration.json"
backend_modules = require("./components/cms/configuration.json").backend_modules
# frontend_modules = require("./components/cms/configuration.json").modules

db = mongoose.connect 'mongodb://localhost/'+config.dbname

module.exports = (grunt)->

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-git'
  grunt.loadNpmTasks 'grunt-bowercopy'

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    less:
      development:
        files: "components/cms/lib/style/main.css": "components/cms/lib/style/main.less"

    watch:
      less:
        files: "components/**/*.less"
        tasks: ["less"]
      scripts:
        files: ['components/**/*.coffee']
        tasks: ['test']
        options:
          spawn: false
      json:
        files:  ['components/**/*.json', '!staticblocks.json']
        tasks: ['jsonlint']
        options:
          spawn: false
      server:
        files: ['server.coffee']
        tasks: ['restart']
        options:
          spawn: false

    coffeelint:
      all:
        options:
          'max_line_length':
            level: 'ignore'
        files:
          src: ['components/cms/**/*.coffee', 'components/frontend/**/*.coffee']

    jsonlint:
      all:
        src:  ['components/**/*.json']

    jasmine:
      cms:
        src: '*.js'
        options:
          specs: 'components/cms/modules/**/spec/*Spec.js'
          helpers: 'components/cms/modules/**/spec/*Helper.js'
          # host : 'http://localhost:1666/admin/'
          template: require 'grunt-template-jasmine-requirejs'
          templateOptions:
            requireConfigFile: 'components/cms/config.js'

    clean:
      everything: src: [
        'bower_components'
        'lib'
        'node_modules'
        'cache'
        'components/cms/vendor'
        'public/files'
      ]
      reinstall: src: [
        'bower_components'
        'lib'
        'cache'
        'components/cms/vendor'
        'public/files'
      ]
      lib: src: [ 'lib' ]
      build: src: [ 'cache/build' ]
      buildBackend: src: [ 'cache/build/cms' ]
      vendorBackend: src: [ 'components/cms/vendor' ]

    mkdir:
      all:
        options:
          create: [
            'cache'
            'public/files'
          ]

    bower:
      install:
        option:
          targetDir: 'bower_components'


    bowercopy:
      cms:
        options:
          destPrefix: "components/cms/vendor"
        files:
          "jquery.js": "jquery/dist/jquery.js"
          "io.js": "socket.io-client/dist/socket.io.js"
          "require.js": "requirejs/require.js"
          "jquery.ui.js": "jquery-ui/jquery-ui.js"
          "jquery.form.js": "jquery-form/jquery.form.js"
          "underscore.js": "underscore/underscore.js"
          "wreqr.js": "backbone.wreqr/lib/backbone.wreqr.js"
          "babysitter.js": "backbone.babysitter/lib/backbone.babysitter.js"
          "backbone.js": "backbone/backbone.js"
          "iobind.js": "backbone.iobind/dist/backbone.iobind.js"
          "iosync.js": "backbone.iobind/dist/backbone.iosync.js"
          "marionette.js": "marionette/lib/backbone.marionette.js"
          "text.js": 'requirejs-text/text.js'
          "tpl.js": 'requirejs-tpl/tpl.js'
          "cs.js": 'require-cs/cs.js'
          "i18n.js": 'requirejs-i18n/i18n.js'
          "coffee-script.js": 'coffee-script/extras/coffee-script.js'
          "notify.js": "notifyjs/dist/notify-combined.min.js"
          "bootstrap.js": "bootstrap/dist/js/bootstrap.js"
          "jquery.minicolors.js": "jquery-minicolors/jquery.minicolors.js"
          "jquery.jcrop.js": "jcrop/js/jquery.Jcrop.js"
          "tinymce": "tinymce-builded/js/tinymce"
          "less.js": "require-less/less.js"
          "less-builder.js": "require-less/less-builder.js"
          "css.js": "require-css/css.js"
          "css-builder.js": "require-css/css-builder.js"
          "normalize.js": "require-css/normalize.js"
          "lessc.js": "require-less/lessc.js"
          "bootstrap-datetimepicker.js": "eonasdan-bootstrap-datetimepicker/src/js/bootstrap-datetimepicker.js"
          "moment.js": "moment/min/moment-with-locales.js"
          # style
          "style": "bootstrap/less"
          "style/boostrap.css": "bootstrap/dist/css/bootstrap.css"
          "style/.": "jcrop/css/*"
          "style/jquery.minicolors.css": "jquery-minicolors/jquery.minicolors.css"
          "style/jquery.minicolors.png": "jquery-minicolors/jquery.minicolors.png"
          "style/bootstrap-datetimepicker.less": "eonasdan-bootstrap-datetimepicker/src/less/bootstrap-datetimepicker.less"

    copy:
      tinymce:
        cwd: 'components/cms/modules/publish/nls/langs-tinymce'
        src: '*'
        dest: 'components/cms/vendor/tinymce/langs'
        expand: true

    requirejs:
      cms:
        options:
          appDir: 'components/cms'
          baseUrl: 'vendor'
          fileExclusionRegExp: /^(server|spec)/
          dir: "cache/build/cms"
          optimizeAllPluginResources: true,
          findNestedDependencies: true,
          stubModules: ['less', 'css', 'cs', 'coffee-script'],
          modules: [{
            name: 'config'
            include: backend_modules
            exclude: ['coffee-script', 'css', 'less']
          }]
          optimize : 'uglify2',
          shim:
            'jquery.tinymce':['jquery', 'tinymce']
            'jquery.ui':['jquery']
            'jquery.minicolors':['jquery']
          paths:
            config: '../config'
            configuration: '../configuration.json'
            lib: '../lib'
            utilities: '../utilities'
            modules: '../modules'
            App: "../utilities/App"
            Oophaga: "../lib/Oophaga"
            Router: '../utilities/Router'
            Utils: '../utilities/Utilities'
            tinymce: 'tinymce/tinymce',
            plugins: 'tinymce/tinymce/plugins',
            'jquery.tinymce': 'tinymce/jquery.tinymce.min',

  # clean db
  grunt.registerTask 'dropDatabase', 'drop the database', ->
    done = this.async()
    db.connection.on 'open', ->
      db.connection.db.dropDatabase (err)->
        if err then console.log err else console.log 'Successfully dropped database'
        mongoose.connection.close done

  grunt.registerTask 'backupDatabase', 'backup the database', ->
    done = this.async()
    spawn = require('child_process').spawn
    mongoexport = spawn('mongodump', ['-d', config.dbname]).on 'exit', (code)->
      if code is 0
        console.log("Backupped Database")
      else
        console.log('Error: while backupDatabase, code: ' + code)
      done()

  grunt.registerTask 'restoreDatabase', 'restore the database', ->
    done = this.async()
    spawn = require('child_process').spawn
    mongoexport = spawn('mongorestore', ['-d', config.dbname], cwd: __dirname+'/dump').on 'exit', (code)->
      if code is 0
        console.log("Restored Database")
      else
        console.log('Error: while restoreDatabase, code: ' + code)
      done()

  grunt.registerTask 'install', 'Install the App', [
    'bower:install'
    'mkdir:all'
    'bowercopy'
    'copy:tinymce' # translations for tinymce
    'clean:lib' #workaround ;()
    'less:development' # precompile less ;D
    'build'
  ]

  grunt.registerTask 'reinstall', 'Reinstalling the App', [
    'dropDatabase'
    'clean:reinstall'
    'install'
  ]
  grunt.registerTask 'reset', 'Reinstalling the App', [
    'dropDatabase'
    'clean:everything'
  ]

  grunt.registerTask 'build', 'Compiles all of the assets and copies the files to the build directory.', [
    'clean:build'
    'requirejs'
  ]

  grunt.registerTask 'buildBackend', 'Compiles all of the assets and copies the files to the build directory.', [
    'clean:cms'
    'requirejs:cms'
  ]

  grunt.registerTask 'test', 'Test the App with Jasmine and JSONlint, Coffeelint', [
    'jsonlint'
    'coffeelint'
    'jasmine'
  ]

  return grunt
