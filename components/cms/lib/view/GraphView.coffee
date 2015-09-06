define [
  'cs!App'
  'jquery'
  'marionette'
  'tpl!../templates/report.html'
  'd3'
  'dc'
  'crossfilter'
  # 'less!../style/viz.less'
], (App, $, Marionette, Template, d3, dc, crossfilter) ->
  class ReportView extends Marionette.ItemView

    width: 1200
    height: 280
    legendwidth: 130
    innerradius: 24

    margins:
      top: 20
      right: 60
      bottom: 30
      left: 46

    template: Template
    events:
      "resize": "resize"
      "click #download": "downloadSvg"

    getDateRange: ->
      date = new Date()
      return [
        new Date date.getFullYear(), 1, 1
        new Date date.getFullYear()+1, 1, 1
      ]


    initialize:->
      @ndx = crossfilter @collection.models
      @userDimension = @ndx.dimension (d)-> d.get 'user'
      @dateDimension = @ndx.dimension (d)-> new Date d.get 'date'
      @dateByWeekDimension = @ndx.dimension (d)-> d3.time.week new Date d.get 'date'
      @dateByMonthDimension = @ndx.dimension (d)-> d3.time.month new Date d.get 'date'
      @dateByDayDimension = @ndx.dimension (d)-> d3.time.day new Date d.get 'date'
      @on 'render', @afterRender
      @listenTo @collection, 'reset', @updateData


    downloadSvg: ->
      svg = @svg[0][0].parentNode.outerHTML
      doctype = '<?xml version="1.0" standalone="no"?> \
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">'
      html = doctype+svg
      blob = new Blob([html], {type: "image/svg+xml;charset=utf-8"})
      saveAs blob, "graph.svg"

    afterRender:->
      $(window).one "resize", => @afterRender()
      @width = @$el.parent().width() or @width
      @initLegend()
      @initChart()
      dc.renderAll()

    initChart: ->
      console.log "no Chart defined"

    getElement: (selector)->
      @$el.find(selector)[0]

    initLegend: ->
      @userlegend = dc.pieChart @getElement "#userlegend"
      @userlegend
        .width @legendwidth
        .height @legendwidth
        .slicesCap 4
        .innerRadius @innerradius
        .dimension @userDimension
        .group @userDimension.group().reduceCount()
        .label (d)-> App.Users.findWhere(_id: d.data.key).get("title")
        .legend dc.legend()

    initChart:->
      # pie = dc.pieChart("#chart-test")
      # stack = dc.barChart("#bar-test")
      path = dc.lineChart @getElement "#chart"
      path
        .width @width
        .height @height
        .margins @margins
        # .rangeChart(volumeChart)
        .brushOn false
        .x d3.time.scale().domain @getDateRange()
        .renderArea true
        .clipPadding 10
        .renderHorizontalGridLines true
        # .title (d)-> "#{d.data.key}, Amount: #{d.data.value}"
        # .xUnits(d3.time.month)
        # .round(d3.time.month.round)
        # .interpolate('step-before')
        .yAxisLabel("Count")
        .renderHorizontalGridLines(true)
        .mouseZoomable true
        .dimension @userDimension
        .group @dateByWeekDimension.group().reduceCount()
