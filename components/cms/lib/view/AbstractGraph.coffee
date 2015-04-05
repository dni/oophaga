define [
  'cs!App'
  'tpl!../templates/filter.html'
  'underscore'
  'marionette'
  'backbone'
  'moment'
  'd3'
  'd3-tip'
  'cs!Utils'# for date .getWeek
  'FileSaver'
], (App, Template, _, Marionette, Backbone, moment, d3, tip) ->

  class Abstractgraph extends Marionette.CompositeView

    tagName: "form"
    template: Template

    events:
      "change select, input": "changeFilter"
      "click #download": "downloadSvg"

    downloadSvg: ->
      svg = @svg[0][0].parentNode.outerHTML
      doctype = '<?xml version="1.0" standalone="no"?> \
      <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">'
      html = doctype+svg
      blob = new Blob([html], {type: "image/svg+xml;charset=utf-8"})
      saveAs blob, "graph.svg"

    filter: {}
    changeFilter:->
      @filter.cumu = false # reset checkbox
      _.forEach @$el.serializeArray(), (filter)=> @filter[filter.name] = filter.value
      @showChart @prepareData()

    initialize:->
      @margin = {top: 50, right: 40, bottom: 150, left: 60}
      @width = 860 - @margin.left - @margin.right
      @height = 660 - @margin.top - @margin.bottom
      @on 'render', @onRender
      @preInit()

    prepareData:->
      that = @
      count = 1

      if @filter.year
        @collection.filter (model)->
          date = new Date model.get(that.filter.x)
          date.getFullYear() is parseInt that.year

      if @filter.groupBy
        @collection.groupBy (model)=>
          date = new Date model.get(that.filter.x)
          return date[@filter.groupBy]()

      sorted = @collection.sortBy (model)->
        date = new Date model.get(that.filter.x)
        date.getTime()

      sorted.map (model)->
        count++ if that.filter.cumu
        date: new Date model.get(that.filter.x)
        value: count
        title: model.getValue("title") or model.getValue("message")
        href: model.getHref()

    preInit:->
      @x = d3.time.scale().range([0, @width])
      @y = d3.scale.linear().range([@height, 0])
      @xAxis = d3.svg.axis()
        .scale(@x)
        .orient("bottom")
      @yAxis = d3.svg.axis()
        .scale(@y)
        .orient("left")
      @color = d3.scale.category20()

    render:->
      @_ensureViewIsIntact()
      @triggerMethod('before:render', this)
      if @template then @$el.prepend @template()
      @svg = d3.select(@el).append("svg")
        .attr "xmlns", "http://www.w3.org/2000/svg"
        .attr("width", @width + @margin.left + @margin.right)
        .attr("height", (@height + @margin.top + @margin.bottom))
        .append("g")
        .attr "transform", "translate(#{@margin.left}, #{@margin.top})"
      @yAxisDom = @svg.append("g").attr("class", "y axis")
        .style("fill", "none").style("stroke", "black")
      @xAxisDom = @svg.append("g").attr("class", "x axis")
        .attr("transform", "translate(0," + @height + ")")
        .style("fill", "none").style("stroke", "black")
      @initChart()
      return @el
