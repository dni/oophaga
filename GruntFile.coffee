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
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-git'
  grunt.loadNpmTasks 'grunt-bowercopy'

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    watch:
      coffee:
        files: ['spec/**/*.coffee'],
        tasks: ['coffee', 'test']
      less:
        files: "components/**/*.less"
        tasks: ["less"]
      scripts:
        files: ['components/**/*.coffee', '!components/**/spec/*.coffee']
        tasks: ['test']
        options:
          spawn: false
      json:
        files:  ['components/**/*.json']
        tasks: ['jsonlint']
        options:
          spawn: false

    coffeelint:
      all:
        options:
          'max_line_length':
            level: 'ignore'
        files:
          src: ['components/cms/**/*.coffee', 'components/cms/**/*.coffee']

    less:
      development:
        files: "components/cms/lib/style/main.css": "components/cms/lib/style/main.less"

    coffee:
      testCms:
        files: 'spec/cms/spec.js': 'spec/cms/*.coffee'
      testApi:
        files: 'spec/api/spec.js': 'spec/api/*.coffee'

    jsonlint:
      all:
        src:  ['components/**/*.json']

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
          "d3.js": 'd3/d3.js'
          "dc.js": 'dcjs/dc.js'
          "fullcalendar.js": 'fullcalendar/dist/fullcalendar.js'
          "d3-tip.js": 'd3-tip/index.js'
          "crossfilter.js": 'crossfilter/crossfilter.js'
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
          "jquery.jcrop.js": "jcrop/js/Jcrop.js"
          "tinymce": "tinymce-builded/js/tinymce"
          "less.js": "require-less/less.js"
          "less-builder.js": "require-less/less-builder.js"
          "css.js": "require-css/css.js"
          "css-builder.js": "require-css/css-builder.js"
          "normalize.js": "require-css/normalize.js"
          "lessc.js": "require-less/lessc.js"
          "googlemaps.js": 'googlemaps-amd/src/googlemaps.js'
          "async.js": 'requirejs-plugins/src/async.js'
          "bootstrap-datetimepicker.js": "eonasdan-bootstrap-datetimepicker/src/js/bootstrap-datetimepicker.js"
          "moment.js": "moment/min/moment-with-locales.js"
          "FileSaver.js": "file-saver/FileSaver.js"
          "mocha.js": 'mocha/mocha.js'
          "chai.js": 'chai/chai.js'
          # "backgrid.js": "backgrid/lib/backgrid.js"
          # "backgrid-filter.js": "backgrid-filter/backgrid-filter.js"
          # "backgrid-select-all.js": "backgrid-select-all/backgrid-select-all.js"
          # style
          "style": "bootstrap/less"
          "style/boostrap.css": "bootstrap/dist/css/bootstrap.css"
          "style/.": "jcrop/css/*"
          "style/fullcalendar.css": 'fullcalendar/dist/fullcalendar.css'
          "style/jquery.minicolors.css": "jquery-minicolors/jquery.minicolors.css"
          "style/jquery.minicolors.png": "jquery-minicolors/jquery.minicolors.png"
          "style/bootstrap-datetimepicker.less": "eonasdan-bootstrap-datetimepicker/src/less/bootstrap-datetimepicker.less"
          # "style/backgrid.css": "backgrid/lib/backgrid.css"
          # "style/backgrid-filter.css": "backgrid-filter/backgrid-filter.css"
          # "style/backgrid-select-all.css": "backgrid-select-all/backgrid-select-all.css"
          "style/dc.css": "dcjs/dc.css"
          "mocha.css": 'mocha/mocha.css'

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
            utilities: '../lib/utilities'
            modules: '../modules'
            App: "../lib/App"
            Router: '../lib/utilities/Router'
            Utils: '../lib/utilities/Utilities'
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
    'coffeelint'
    'jasmine'
  ]

  return grunt
