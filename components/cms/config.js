require.config({
  baseUrl: 'vendor',
  paths: {
    lib: '../lib',
    utilities: '../lib/utilities',
    modules: '../modules',
    sysmodules: '../sysmodules',
    configuration: '../configuration.json',
    App: "../lib/App",
    Router: '../lib/utilities/Router',
    Utils: '../lib/utilities/Utilities',
    tinymce: 'tinymce/tinymce',
    'jquery.tinymce': 'tinymce/jquery.tinymce.min',
  },
  shim: {
    bootstrap: {
      deps: ['jquery']
    },
    'crossfilter': {
      deps: [],
      exports: 'crossfilter'
    },
    'jquery.tinymce':['jquery', 'tinymce'],
    'minicolors':['jquery'],
    'fullcalendar':['jquery', 'moment'],
    'backgrid': {
      deps: ['jquery', 'underscore', 'backbone'],
      exports: 'Backgrid'
    },
    'backgrid-select-all': { deps: ['backbone', 'backgrid']},
    'backgrid-filter': { deps: ['backbone', 'backgrid']},
  }
});
require(['cs!App', 'backbone', 'jquery', 'bootstrap'], function(App, Backbone, $){
    App.init()
    App.vent.on('ready', function(){
      App.isReady = true
      console.log("App is now ready");
      Backbone.history.start();
    });
});
