define [
  'cs!App'
  'underscore'
  'i18n!lib/nls/language'
  'text!lib/templates/buttons.html'
  'text!lib/templates/value.html'
  'text!lib/templates/field.html'
  'text!./meta-attributes.json'
], (App, _, i18n, buttonTemplate, valueTemplate, fieldTemplate, metaAttributes) ->

  Viewhelpers =
    getModel: (field)->
      App[field.collection].findWhere _id: field.value

    formatDate: (date)->
      if date not typeof Date then date = new Date(date)
      date.format()

    renderButtons: (notpublishable, published)->
      compiled = _.template buttonTemplate
      compiled _.extend i18n, "notpublishable": notpublishable

    renderEdit: (id)->
      compiled = _.template """
      """
      compiled _.extend i18n, moduleName: @Config.moduleName, id: id

    renderValue: (column, attributes)->
      compiled = _.template valueTemplate
      compiled _.extend @, i18n: i18n, column:column, attributes: attributes, config: @config, App: App, metaAttributes: JSON.parse metaAttributes

    renderField: (key, attribute)->
      compiled = _.template fieldTemplate
      compiled _.extend @, key:key, attribute: attribute

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
      if attribute.setting
        setting = App.Settings.findWhere title: @Config.moduleName
        values = setting.get("fields")[attribute.setting].value.split(',')
        for option in values
          options[option.trim()] = option.trim()
        return options
      return attribute.options

    foreachAttribute: (model, cb)->
      unless @Config.fields? # setting
        for key of model.fields
          cb key, model.fields[key]
      else
        for key in @Config.fields
          field = @Config.model[key] or fields[key]
          field.value = model[key]
          cb key, field

    foreachMetaAttribute: (model, cb)->
      fields = JSON.parse metaAttributes
      Object.keys(fields).forEach (key)->
        field = fields[key]
        field.label = i18n[key]
        field.value = model[key]
        cb key, field

