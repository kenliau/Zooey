$ ->
  # Tracker segments
  pull = $('.tracker-pull')
  tcoder = $('.tracker-tcoder')
  chunker = $('.tracker-chunker')
  merger = $('.tracker-merger')

  #$.ajax
    #type: 'GET'
    #url: 'jobs/status/1'
    #success: (response) ->
      #console.log response
    #error: (response) ->
      #console.log response

  pulse = (segment) ->
    setInterval ->
      segment.toggleClass 'complete'
    , 400


  interval_id = pulse(pull)

  setTimeout ->
    clearInterval interval_id
  , 4001
