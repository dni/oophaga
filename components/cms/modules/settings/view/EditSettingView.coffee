define [
  'cs!lib/view/EditView'
  'tpl!../templates/edit.html'
], (EditView, Template ) ->
  class EditSettingView extends EditView

    getFields: ->
      @model.get "fields"

    setValuesFromUi: ()->
      fields = @getFields()
      Object.keys(fields).forEach (key)=>
        field = fields[key]
        return unless @ui[key]?
        console.log field
        if field.type is "date"
          field.value = @ui[key].parent().data("DateTimePicker").getDate()
        if field.type is "checkbox"
          field.value = @ui[key].prop('checked')
        else
          field.value = @ui[key].val()
      @model.set "fields", fields
