define [
  'jquery'
  'cs!Router'
  'marionette'
  'tpl!../templates/showfile.html'
], ($, Router, Marionette, Template) ->

  class ShowFileView extends Marionette.ItemView
    template: Template
    events:
      "click .deleteFile": "deleteFile"
      "click .editFile": "editFile"

    deleteFile: ->
      $('.modal').modal('hide')
      @model.destroy
        success:->

    editFile: ->
      Router.navigate "##{@options.moduleName}/edit/#{@model.get("_id")}", trigger:true
