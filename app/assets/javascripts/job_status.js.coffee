$ ->
  meter = $('.meter')
  job = $('#job-data')
  job_id = parseInt(job.data('job-id'), 10)

  meter.on 'update', (e, width) ->
    width = 100 if width >= 100
    percentage = width + '%'
    $(this).animate width: percentage

  poll = () ->
    $.ajax
      url: '/jobs/progression/' + job_id,
      type: 'GET',
      success: (response) ->
        width = if response.processed == 0 then 0 else (response.processed / response.size)*100
        meter.trigger 'update', width

  setInterval(poll, 2000)
