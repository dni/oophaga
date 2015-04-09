require.config({
  baseUrl: 'vendor',
  paths: {
    lib: '../lib',
    utilities: '../lib/utilities',
    modules: '../modules',
    configuration: '../configuration.json',
    App: "../lib/utilities/App",
    Oophaga: "../lib/Oophaga",
    Router: '../lib/utilities/Router',
    Utils: '../lib/utilities/Utilities',
    tinymce: 'tinymce/tinymce',
    'jquery.tinymce': 'tinymce/jquery.tinymce.min',
  },
  shim: {
    'jquery.tinymce':['jquery', 'tinymce'],
    'minicolors':['jquery'],
    'fullcalendar':['jquery', 'moment'],
  }
});
require(['cs!App','text!configuration', 'backbone', 'jquery'], function(App, configJSON, Backbone, $){

    $(document).off('.data-api');
    var config = JSON.parse(configJSON).backend_modules;
    require(config, function(){
      for(var i = 0; i < arguments.length;i++) {
        arguments[i].init();
      }
    });

    App.vent.on('ready', function(){
      Backbone.history.start();
      console.log("App is now ready");
    });
});
