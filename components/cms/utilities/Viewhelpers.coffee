define [
  'cs!App'
  'underscore'
  'i18n!modules/cms/nls/language'
  'text!lib/templates/buttons.html'
  'text!lib/templates/field.html'
], (App, _, i18n, buttonTemplate, fieldTemplate) ->

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

    isPrint:->
      setting = App.Settings.findSetting "MagazineModule"
      setting.getValue 'print'

    getOptions:(attribute)->
      options = {}
      if attribute.collection
        App[attribute.collection].forEach (model)->
          options[model.get("_id")] = model.getValue("title")
        return options
      if attribute.setting
        setting = App.Settings.findSetting @Config.moduleName
        values = setting.getValue(attribute.setting).split(',')
        for option in values
          options[option.trim()] = option.trim()
        return options
      return attribute.options

    foreachAttribute: (fields, cb)->
      keys = Object.keys(fields)
      fieldsArray = @Config.fields or keys.splice(0,keys.length-1)
      for key in fieldsArray
        field = fields[key]
        field = @Config.model[key] unless field?
        cb key, field

    foreachMetaAttribute: (model, cb)->
      fields =
        published:
          value: model.published
          type: "checkbox"
        date:
          value: model.date
          disabled: true
          type: "date"
        crdate:
          value: model.crdate
          disabled: true
          type: "date"
        user:
          value: model.user
          disabled: true
          collection: "Users"
          type: "select"
        cruser:
          value: model.cruser
          disabled: true
          collection: "Users"
          type: "select"

      Object.keys(fields).forEach (key)->
        field = fields[key]
        cb key, field

