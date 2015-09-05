define [
  'cs!App'
  'cs!lib/controller/Controller'
  'cs!lib/view/TopView'
  'cs!../view/MessageListView'
  'cs!../view/MessageDetailView'
], ( App, Controller, TopView, ListView, DetailView) ->
  class MessageController extends Controller
    list : ->
      App.listTopRegion.show new TopView navigation:@i18n.navigation
      App.listRegion.show new ListView
      App.contentRegion.show new DetailView collection: App.Messages
