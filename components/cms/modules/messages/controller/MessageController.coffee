define [
  'cs!App'
  'cs!Oophaga'
  'cs!../view/MessageListView'
  'cs!../view/MessageDetailView'
], ( App, Oophaga, ListView, DetailView) ->
  class MessageController extends Oophaga.Controller.Controller
    list : ->
      App.listTopRegion.show new Oophaga.View.TopView navigation:@i18n.navigation
      App.listRegion.show new ListView
      App.contentRegion.show new DetailView collection: App.Messages
