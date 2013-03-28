$ ->
  meter = $('.progress.meter')
  job = $('#job-data')
  job_id = parseInt(job.data('job-id'), 10)

  meter.on 'progress_update', (width) ->
    percentage = width + '%'
    this.css 'width', percentage

  poll = () ->
    $.ajax 
      url: '/jobs/progressions/' + job_id,
      type: 'GET',
      success: (response) ->
        console.log response
        width = processed / size
        meter.trigger 'progress_update', width

  setInterval(poll, 10000)
