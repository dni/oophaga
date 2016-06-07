define [
  'cs!App'
  'underscore'
  'text!lib/templates/buttons.html'
  'text!lib/templates/value.html'
  'text!lib/templates/field.html'
  'i18n!nls/lib'
], (App, _, buttonTemplate, valueTemplate, fieldTemplate, i18n) ->

  metaconfig = {}
  App.vent.on "ready", ->
    metaconfig = App.SysConfig.get "metaconfig"

  dateformat = i18n.dateformat

  Viewhelpers =
    metai18n: i18n

    getModel: (field)->
      App[field.collection].findWhere _id: field.value

    formatDate: (date)->
      if date not typeof Date then date = new Date(date)
      date.format()

    renderButtons: (notpublishable, published)->
      compiled = _.template buttonTemplate
      compiled _.extend i18n, "notpublishable": notpublishable

    renderValue: (key, value)->
      model = @Config.get("modelconfig")[key]
      model = App.SysConfig.attributes.metaconfig[key] if !model
      compiled = _.template valueTemplate
      compiled _.extend @, dateformat: dateformat, model: model, value: value, config: @config, App: App

    renderField: (key, value)->
      compiled = _.template fieldTemplate
      attribute = @Config.get("modelconfig")[key]
      attribute = App.SysConfig.attributes.metaconfig[key] if !attribute
      attribute.label = @i18n.attributes[key] or @metai18n.attributes[key]
      compiled _.extend @, attribute: attribute, key: key, value: value

    checkCondition: (condition)->
      @[condition]()

    elAttr: (attr)->
      string = ""
      string += " disabled='disabled'" if attr.disabled
      string += " required='required'" if attr.required
      string

    getOptions:(attribute)->
      options = {}
      if attribute.collection
        App[attribute.collection].forEach (model)->
          options[model.get("_id")] = model.get attribute.label
        return options
      return attribute.options

    foreachAttribute: (cb)->
      fields = @Config.get "modelconfig"
      Object.keys(fields).forEach cb

    foreachMetaAttribute: (cb)->
      Object.keys(metaconfig).forEach cb
