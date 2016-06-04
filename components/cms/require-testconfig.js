require.config({
  baseUrl: 'vendor',
  paths: {
    spec: '../spec',
    lib: '../lib',
    utilities: '../lib/utilities',
    modules: '../modules',
    configuration: '../configuration.json',
    App: "../lib/App",
    Router: '../lib/utilities/Router',
    Utils: '../lib/utilities/Utilities',
    tinymce: 'tinymce/tinymce',
    'jquery.tinymce': 'tinymce/jquery.tinymce.min',
  },
  shim: {
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
require([
    // tests
     'cs!spec/AppSpec',
     'cs!spec/InitAppSpec',
     'cs!spec/ModuleSpec'
     ], function() {
       if (window.mochaPhantomJS) { mochaPhantomJS.run(); }
       else { mocha.run(); }
     }
);
