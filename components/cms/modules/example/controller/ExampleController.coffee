define [
  'cs!Oophaga'
  'cs!modules/files/view/RelatedFileView'
],
( Oophaga, RelatedFileView) ->

  class SimpleView extends Oophaga.View.ListView
    relatedView: true
    collectionName: "Simples"
    i18n: attributes: title: "Text"
    fieldName: "selectmodel"
    columns: ["title"]

  class SettingsController extends Oophaga.Controller.LayoutController
    RelatedViews:
      fileView: RelatedFileView
      simpleView: SimpleView
