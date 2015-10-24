define [
  "backbone"
  "underscore"
  "cs!./Model"
], (Backbone, _, Model) ->

  class Collection extends Backbone.Collection

    # intial code from http://stackoverflow.com/a/14966131/484780
    # NOTE: needs improved (objects as values)
    saveToCSV: (downloadName)->
      downloadName = 'download' unless downloadName
      if this.length is 0 then return console.log('no data to export')

      header = _.keys(this.first().csvData())
      rows = this.map (m)-> return _.values m.csvData()
      data = [header].concat(rows)

      data = _.map data, (row)->
        _.map row, (val, key)->
          if _.isString(val) and val.match(/,|\n|"/)
            val = '"'+val+'"'
          else if _.isArray(val)
            val = '"'+val.toString()+'"'
          return val

      csvContent = "data:text/csv;charset=utf-8,"
      data.forEach (infoArray, index)->
        dataString = infoArray.join(",")
        csvContent += if index < data.length then dataString+ "\n" else dataString

      encodedUri = encodeURI(csvContent)
      link = document.createElement("a")
      link.setAttribute("href", encodedUri)
      link.setAttribute("download", downloadName+".csv")
      link.click()

    findSetting:(moduleName)->
      arr = _.filter @.models, (model)->
        return model.attributes.fields?.title?.value is moduleName
      return arr[0]

    getCalendarEvents: ->
      return @calendarevents if @calendarevents
      @calendarevents = @map (model)-> model.getCalenderEvent()
