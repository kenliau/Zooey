$ ->
  meter = $('.progress.meter')
  job = $('#job-data')
  job_id = parseInt(job.data('job-id'), 10)

  meter.on 'progress_update', (width) ->
    percentage = width + '%'
    this.css 'width', percentage

  poll = () ->
    $.ajax 
      url: '/jobs/progression/' + job_id,
      type: 'GET',
      success: (response) ->
        width = if response.processed == 0 then 0 else response.processed / response.size
        meter.trigger 'progress_update', width

  setInterval(poll, 5000)
