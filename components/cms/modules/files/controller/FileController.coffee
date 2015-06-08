define [
  'cs!App'
  'cs!Oophaga'
  'cs!Router'
  'cs!../view/BrowseView'
  'cs!../view/ShowFileView'
  'cs!../view/EditFileView'
  'cs!../view/PreviewView'
], ( App, Oophaga, Router, BrowseView, ShowFileView, EditFileView, PreviewView) ->

  class FileController extends Oophaga.Controller.Controller

    RelatedViews:
      preview: PreviewView

    filterFunction: (file)->
      !file.parent?

    show: (id) ->
      App.overlayRegion.currentView.childRegion.show new ShowFileView
        moduleName: @Config.moduleName
        model: App.Files.findWhere _id: id

    # edit: (id) ->
    #   App.overlayRegion.currentView.childRegion.show new EditFileView
    #     model: App.Files.findWhere _id: id

