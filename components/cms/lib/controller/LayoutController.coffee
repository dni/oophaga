define [
  'cs!App'
  'cs!lib/controller/Controller'
  'cs!lib/view/RelatedListView'
], ( App, Controller, RelatedView ) ->
  class LayoutController extends Controller

    constructor: (args)->
      super args
      unless @RelatedViews? then return c.l "no related Views, try to specify RelatedViews, or simply use the Standard Controller"
      unless @RelatedView? then @RelatedView = RelatedView

    newEditView:(model)->
      @detailView = new @EditView
        model: model
        Config: @Config
        i18n: @i18n
        relatedView: new @RelatedView
          model: model
          RelatedViews: @RelatedViews
