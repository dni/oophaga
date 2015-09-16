define [
  'cs!lib/view/ListView'
  'cs!lib/controller/LayoutController'
  'cs!sysmodules/files/view/RelatedFileView'
],
( ListView, LayoutController, RelatedFileView) ->

  class SimpleView extends ListView
    relatedView: true
    collectionName: "Simples"
    i18n: attributes: title: "Text"
    fieldName: "selectmodel"
    columns: ["title"]

  class ExampleController extends LayoutController

    customaction: ->
      alert "custom action"

    RelatedViews:
      fileView: RelatedFileView
      # simpleView: SimpleView
