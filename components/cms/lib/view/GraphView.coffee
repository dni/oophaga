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
      @tip = tip()
        .attr 'class', 'd3-tip'
        .offset [-10,0]
        .html (d)-> "<span>#{d.title}</span>"
      @svg.call @tip
      @path = @svg.append('g').append('path').style("fill", "none").style("stroke", "grey")
      @arc = d3.svg.arc().outerRadius(200 - 10).innerRadius 100
      @pie = d3.layout.pie().sort(null).value (d)-> d.value
      @changeFilter()

    showChart: (data)->
      that = @
      if @filter.type is "pie"
        @pieDom = @svg.selectAll(".arc").data(that.pie(data))
        @pieDom.exit().remove()
        pieEnter = @pieDom.enter().append("g")
          .attr("class","arc")
          .attr "transform", "translate(200, 200)"
        pieEnter.append("path")
          .attr "fill", (d,i)-> that.color i
          .attr("d", @arc)
        pieEnter.append("text")
          .attr "transform", (d)-> "translate(" + that.arc.centroid(d) + ")"
          .text (d)-> d.data.title.slice(0, -5)

      if @filter.type is "path"
        @x.domain d3.extent data, (d)-> d.date
        @y.domain [0, d3.max data, (d)-> d.value]
        @yAxisDom.call(@yAxis)
        @xAxisDom.call(@xAxis)
        @path.datum(data).transition()
          .attr("class", "line")
          .attr("d", that.line)

      if @filter.type is "bar"
        x = d3.scale.ordinal().rangeRoundBands([0, @width], .1)
        x.domain d3.extent data, (d)-> d.date
        xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")

        @svg.selectAll(".bar")
          .data(data)
          .enter().append("rect")
          .attr "fill", "grey"
          .attr("class", "bar")
          .attr "x", (d)-> x(d.date)
          .attr("width", x.rangeBand())
          .attr "y", (d)-> that.y(d.value)
          .attr "height", (d)-> that.height - that.y(d.value)

        @yAxisDom.call(@yAxis)
        @xAxisDom.call(xAxis)

      hype = @svg.selectAll(".hype").data(data)
      hype.enter()
        .append("circle").attr("class", "hype")
        .attr("r", 6)
        .style("fill", "grey")
        .on("mouseover", that.tip.show)
        .on("mouseout", that.tip.hide)
        .on "click", (d)-> Router.navigate d.href, trigger:true
      hype.transition()
        .attr "transform", (d)-> "translate(" + that.x(d.date) + "," + that.y(d.value) + ")"
      hype.exit().remove()

