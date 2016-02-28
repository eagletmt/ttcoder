@renderGraph = (url) ->
  $(document).ready ->
    $.ajax(url).done (json) ->
      new Highcharts.Chart(
        chart:
          type: 'line'
          renderTo: 'weekly-graph'
        title:
          text: 'Weekly Accepts'
        xAxis:
          categories: json.dates
        yAxis:
          title:
            text: ''
        legend:
          layout: 'vertical'
          align: 'right'
          verticalAlign: 'middle'
        series: ({name: k, data: v} for own k, v of json.accepts)
      )
