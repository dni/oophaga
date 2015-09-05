define [
  'cs!App'
  'cs!lib/controller/Controller'
  'cs!Router'
  'cs!../view/BrowseView'
  'cs!../view/ShowFileView'
  'cs!../view/EditFileView'
  'cs!../view/PreviewView'
], ( App, Controller, Router, BrowseView, ShowFileView, EditFileView, PreviewView) ->

  class FileController extends Controller

    RelatedViews:
      preview: PreviewView

    filterFunction: (file)->
      !file.parent?

    show: (id) ->
      App.view.overlayRegion.currentView.childRegion.show new ShowFileView
        moduleName: @Config.moduleName
        model: App.Files.findWhere _id: id

    # edit: (id) ->
    #   App.overlayRegion.currentView.childRegion.show new EditFileView
    #     model: App.Files.findWhere _id: id

