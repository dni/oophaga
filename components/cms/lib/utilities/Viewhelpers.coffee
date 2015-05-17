define [
  'cs!App'
  'underscore'
  'i18n!lib/nls/language'
  'text!lib/templates/buttons.html'
  'text!lib/templates/field.html'
  'text!./meta-attributes.json'
], (App, _, i18n, buttonTemplate, fieldTemplate, metaAttributes) ->

  Viewhelpers =
    getModel: (field)->
      App[field.collection].findWhere _id: field.value

    formatDate: (date)->
      if date not typeof Date then date = new Date(date)
      date.format()

    renderButtons: (notpublishable, published)->
      _.template buttonTemplate, _.extend i18n, "notpublishable": notpublishable

    renderField: (key, attribute)->
      _.template fieldTemplate, _.extend @, key:key, attribute: attribute

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
          options[model.get("_id")] = model.get("title")
        return options
      if attribute.setting
        setting = App.Settings.findSetting @Config.moduleName
        values = setting.get(attribute.setting).split(',')
        for option in values
          options[option.trim()] = option.trim()
        return options
      return attribute.options

    foreachAttribute: (model, cb)->
      for key in @Config.fields
        field = @Config.model[key]
        field.value = model[key]
        cb key, field

    foreachMetaAttribute: (model, cb)->
      fields = JSON.parse metaAttributes
      Object.keys(fields).forEach (key)->
        field = fields[key]
        field.label = i18n[key]
        field.value = model[key]
        cb key, field

