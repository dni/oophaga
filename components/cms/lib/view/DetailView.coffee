define [
  'cs!App'
  'cs!Oophaga'
  'i18n!lib/nls/language'
  'cs!lib/model/Collection'
  'cs!Utils'
  'cs!Router'
  'marionette'
  'tpl!lib/templates/detail.html'
  'cs!modules/files/view/RelatedFileView'
  'bootstrap-datetimepicker'
  'jquery.tinymce'
  'jquery.minicolors'
  'bootstrap'
], (App, Oophaga, i18n, Collection, Utils, Router, Marionette, Template, RelatedFileView, datetimepicker, tinymce, minicolors, bootstrap) ->

  #important for build
  tinyMCE.baseURL = "/vendor/tinymce"

  class DetailView extends Marionette.LayoutView
    template: Template
    regions:
      relatedRegion: "#relations"

    initialize:(args)->
      @model = args.model
      @relatedView = args.relatedView
      @ui = published: "[name=published]"
      @ui[key] = "[name="+key+"]" for key, arg of args.Config.model
      @bindUIElements()
      @listenTo @model, 'change', @render
      @on "render", @afterRender, @

    afterRender:->
      @renderRelatedViews()
      @initFields()

    templateHelpers: ->
      vhs: _.extend Utils.Viewhelpers, Config: @options.Config, t: attributes: _.extend @options.i18n.attributes, i18n.attributes

    getValuesFromUi: ()->
      fields = @options.Config.model
      for key, field of fields
        return unless @ui[key]
        field.value = @ui[key].val()
        if field.type is "date"
          field.value is @ui[key].parent().data("DateTimePicker").getDate()
        if field.type is "checkbox"
          field.value = @ui[key].prop('checked')
      return fields

    showRelatedView: =>
      @$el.find('#relation-tab').show()
      @relatedRegion.show @relatedView

    renderRelatedViews: ->
      # show related Views
      if @relatedView
        # dont create subviews if model is new and there is no _id for the relation
        if !@model.isNew() then @showRelatedView()
        else @model.on "sync", @showRelatedView, @
      # fileview as field type file
      fields = @model.get "fields"
      @RelatedViews = {}
      for key, field of fields
        if field.type is "file"
          @RelatedViews[key] = new RelatedFileView
            model: @model
            fieldrelation: key
            collection : new Collection
            multiple: field.multiple
          @RelatedViews[key].render()
          @on "close", => @RelatedViews[key].destroy()
          if @model.isNew() then @$el.find('#'+key).parent().hide().addClass('related-view')
          @$el.find('#'+key).append @RelatedViews[key].el

    events:
      "click .save": "save"
      "click .saveclose": "saveClose"
      "click .savenew": "saveNew"
      "click .cancel": "cancel"
      "click .delete": "deleteModel"

    saveNew: =>
      @save()
      Router.navigate @options.Config.moduleName+"/new", trigger:true

    saveClose: =>
      @save()
      @cancel()

    cancel: =>
      App.detailRegion.empty()
      Router.navigate @options.Config.moduleName, trigger: !App.contentRegion.currentView?

    save: (done)->
      @model.set "fields", @getValuesFromUi()
      #set geolocation
      App.getCurrentPosition()
      @model.setLocation [App.position.coords.latitude, App.position.coords.longitude]
      @model.set "published", @ui.published.prop("checked")
      that = @
      if @model.isNew()
        App[that.options.Config.collectionName].create @model,
          wait: true # related views
          success: (res) ->
      else
        @model.save()

    deleteModel: ->
      App.detailRegion.empty()
      Router.navigate @options.Config.moduleName, trigger:true
      @model.destroy
        success: ->

    initFields: ->
      @$el.find(".datepicker").datetimepicker showToday:true
      @$el.find('[data-toggle=tooltip]').tooltip
        placement: 'right'
        container: 'body'
      @$el.find(".colorpicker").minicolors
        control: $(this).attr('data-control') || 'hue'
        inline: $(this).attr('data-inline') == 'true'
        position: $(this).attr('data-position') || 'top left'
        change: (hex, opacity)-> true
        theme: 'bootstrap'
      # tinymce
      setTimeout =>
        @$el.find(".wysiwyg").tinymce
          theme: "modern"
          baseURL: '/vendor/tinymce'
          menubar : false
          language: i18n.langCode
          convert_urls: true,
          remove_script_host:false,
          relative_urls : true,
          toolbar1: "insertfile undo redo | table | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link code"
          plugins: [
              "advlist autolink lists link charmap print preview hr anchor pagebreak",
              "searchreplace wordcount code fullscreen",
              "insertdatetime nonbreaking table contextmenu directionality",
              "paste"
          ]
      , 50
