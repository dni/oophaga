define [
  'cs!./AbstractGraph'
  "cs!Router"
  'd3'
  'd3-tip'
], (AbstractGraph, Router, d3, tip) ->

  class GraphView extends AbstractGraph

    initChart:->
      that = @
      @line = d3.svg.line()
        .x (d)-> that.x(d.date)
        .y (d)-> that.y(d.value)
      @xAxis = d3.svg.axis()
        .scale(@x)
      @tip = tip()
        .attr 'class', 'd3-tip'
        .offset [-10,0]
        .html (d)-> "<span>#{d.title}</span>"
      @svg.call @tip
      @path = @svg.append('g').append('path')
        .style("fill", "none")
        .style("stroke", "grey")
      @changeFilter()


    showChart: (data)->
      that = @

      @x.domain d3.extent data, (d)-> d.date
      @y.domain [0, d3.max data, (d)-> d.value]
      @yAxisDom.call(@yAxis)
      @xAxisDom.call(@xAxis)

      @path.datum(data).transition()
        .attr("class", "line")
        .attr("d", that.line)

      hype = @svg.selectAll(".hype").data(data)
      hype.enter()
        .append("circle").attr("class", "hype")
        .attr("r", 10)
        .style("fill", "#c50e3d")
        .on("mouseover", that.tip.show)
        .on("mouseout", that.tip.hide)
        .on "click", (d)-> Router.navigate d.href, trigger:true
      hype.transition()
        .attr "transform", (d)-> "translate(" + that.x(d.date) + "," + that.y(d.value) + ")"
      hype.exit().remove()

