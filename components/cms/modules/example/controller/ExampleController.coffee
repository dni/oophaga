define [
  'cs!lib/view/ListView'
  'cs!lib/controller/LayoutController'
  'cs!modules/files/view/RelatedFileView'
],
( ListView, LayoutController, RelatedFileView) ->

  class SimpleView extends ListView
    relatedView: true
    collectionName: "Simples"
    i18n: attributes: title: "Text"
    fieldName: "selectmodel"
    columns: ["title"]

  class SettingsController extends LayoutController
    RelatedViews:
      fileView: RelatedFileView
      simpleView: SimpleView
