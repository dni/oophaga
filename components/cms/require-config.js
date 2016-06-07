require.config({
  baseUrl: 'vendor',
  paths: {
    lib: '../lib',
    nls: '../nls',
    utilities: '../lib/utilities',
    Utils: '../lib/utilities/Utilities',
    modules: '../modules',
    sysmodules: '../sysmodules',
    App: "../lib/App",
    Router: '../lib/utilities/Router',
    tinymce: 'tinymce/tinymce',
    io: '/socket.io/socket.io',
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
  }
});
require(['cs!App', 'backbone', 'jquery', 'bootstrap'], function(App, Backbone, $){

    App.init()
    App.vent.on('ready', function(){
      App.isReady = true
      Backbone.history.start();
      console.log("App is now ready");
    });
});
