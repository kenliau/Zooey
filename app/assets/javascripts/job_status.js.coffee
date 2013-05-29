if onJobShow() then $ ->

  vent = _.extend({}, Backbone.Events)

  # ChartJS
  renderSizeChart = (originalSize, outputSize) ->
    chartElement = $("#sizeChart")
    if chartElement.length < 1 or chartElement.hasClass('rendered') then return
    chartElement.addClass('rendered')

    outputSize ||= parseInt(chartElement.data('output-size'), 10)
    originalSize ||= parseInt(chartElement.data('original-size'), 10)
    ctx = chartElement.get(0).getContext("2d")
    data = [
      value: outputSize
      color: "#67bf95"
    ,
      value: originalSize
      color: "#22c9e3"
    ]
    ratio = (originalSize/outputSize).toFixed(2)
    sizeChart = new Chart(ctx).Doughnut(data,
      { onAnimationComplete : ->
          # write ratio
          ctx.font = "bold 27px sans-serif"
          ctx.fillText(ratio, 100, 130)
          ctx.fillStyle = "#67bf95"
          ctx.fillText(1, 170, 190)

          # straight divider line
          ctx.lineWidth = 4
          ctx.strokeStyle = "#333"
          ctx.beginPath()
          ctx.moveTo(100, 150)
          ctx.lineTo(200, 150)
          ctx.stroke()
      }
    )


  renderSpeedChart = (pullSpeed, transcodeSpeed) ->
    chartElement = $('#speedChart')
    if chartElement.length < 1 or chartElement.hasClass('rendered') then return
    chartElement.addClass('rendered')

    pullSpeed ||= parseInt(chartElement.data('pull-speed'), 10)
    transcodeSpeed ||= parseInt(chartElement.data('transcode-speed'), 10)
    ctx = chartElement.get(0).getContext("2d")

    data =
      labels: ["Speed"]
      datasets: [
        fillColor: "rgba(220,220,220,0.5)"
        strokeColor: "rgba(220,220,220,1)"
        data: [pullSpeed]
        ,
          fillColor: "rgba(151,187,205,0.5)"
          strokeColor: "rgba(151,187,205,1)"
          data: [transcodeSpeed]
      ]

    speedChart = new Chart(ctx).Bar(data,
      { onAnimationComplete : ->
          ctx.font = "bold 12px sans-serif"
          ctx.fillStyle = "#333"
          ctx.fillText( 'in  MB/sec', 255, 292)
      }
    )
    return

  renderMilestonesChart = (milestones) ->
    chartElement = $('#milestonesChart')
    if chartElement.length < 1 or chartElement.hasClass('rendered') then return
    chartElement.addClass('rendered')

    milestones.pullStart      ||= chartElement.data('pull-start')
    milestones.pullFinish     ||= chartElement.data('pull-finish')
    milestones.chunkerStart   ||= chartElement.data('chunker-start')
    milestones.chunkerFinish  ||= chartElement.data('chunker-finish')
    milestones.tcoderStart    ||= chartElement.data('tcoder-start')
    milestones.tcoderFinish   ||= chartElement.data('tcoder-finish')
    milestones.mergerStart    ||= chartElement.data('merger-start')
    milestones.mergerFinish   ||= chartElement.data('merger-finish')

    ctx = chartElement.get(0).getContext('2d')
    data = [
      value: (Date.parse(milestones.pullFinish) - Date.parse(milestones.pullStart)) / 1000
      color: "#F7464A"
    ,
      value: (Date.parse(milestones.chunkerFinish) - Date.parse(milestones.chunkerStart)) / 1000
      color: "#D4C739"
    ,
      value: (Date.parse(milestones.tcoderFinish) - Date.parse(milestones.tcoderStart)) / 1000
      color: "#B3F2F9"
    ,
      value: (Date.parse(milestones.mergerFinish) - Date.parse(milestones.mergerStart)) / 1000
      color: "#F209D4"
    ]
    polarChart = new Chart(ctx).PolarArea(data,
      { onAnimationComplete : ->
          ctx.font = "bold 12px sans-serif"
          ctx.fillStyle = "#333"
          ctx.fillText( 'in seconds', 247, 292)
      }
    )

  renderSizeChart()
  renderSpeedChart()
  renderMilestonesChart({})

  # Backbone
  class Job extends Backbone.Model
    urlRoot: '/jobs'

  class VideoView extends Backbone.View
    el: '#video-table-body'
    initialize: ->
      @listenTo(@model, 'change', @render)
      return
    template: template('video-template')
    render: =>
      current_video = @model.toJSON()
      $(@el).html(@template(current_video))
      return this


  class JobView extends Backbone.View
    el: '#job-table-body'
    initialize: ->
      @listenTo(@model, 'change', @render)
      return
    template: template('job-template')
    render: =>
      current_job = @model.toJSON()
      if (current_job.finished_at?)
        $(@el).html(@template(current_job))
        vent.trigger('job:finish')
        @stopListening
      return this

  class DestroyJobView extends Backbone.View
    el: '#destroy-button'
    template: template('destroy-job-template')
    initialize: ->
      @listenTo(@model, 'change', @render)
    render: =>
      json = @model.toJSON()
      $.each json.status, (s, val) =>
        $.each val, (i, val) =>
          if i == 'error'
            #error = 'There is an error. Please delete this job and try again later.'
            $(@el).html(@template(json))
            return this


  class ProgressView extends Backbone.View
    el: '#progress-row'
    template: template('progression-template')
    initialize: ->
      @listenTo(@model, 'change', @render)
      return
    render: =>
      $(@el).html(@template(@model.toJSON()))
      return this


  class ProgressBarView extends Backbone.View
    el: '#job-status'
    initialize: ->
      @listenTo(@model, 'change', @render)
      return
    render: =>
      current_job = @model.toJSON()
      if current_job.finished_at?
        @stopListening()
        if $('.completed-job').length > 0 then return this
        finished_template = template('finished-job-template')(@model.toJSON())
        $(@el).append(finished_template)
        vent.trigger 'canvas:drawn'
      else
        vent.trigger(
          'progress:change',
          current_job.status.pull,
          current_job.status.transcode,
          current_job.video.size
        )


  job = new Job id: onJobShow()
  jobView = new JobView model: job
  videoView = new VideoView model: job
  destroyJobView = new DestroyJobView model: job
  progressView = new ProgressView model: job
  progressBarView = new ProgressBarView model: job

  refresher = setInterval ->
    job.fetch()
  , 2500

  progressBars = $('.progress-bar')

  vent.on 'progress:change', (pull, transcode, size) ->
    progressBars.each ->
      data = if $(this).hasClass('pull-progress-bar') then pull else transcode
      percentage = (data.bytes / size) * 100
      if percentage > 100 then percentage = 100
      percentage = "#{percentage}%"
      $(this).find('.speed').html("Speed: #{data.speed} MB/s")
      $(this).find('.meter').animate(width: percentage)

  vent.on 'canvas:drawn', ->
    jobData = job.toJSON()
    progress = jobData.progression
    status = jobData.status
    renderSizeChart(jobData.video.size, jobData.output_size)
    renderSpeedChart(status.pull.speed, status.transcode.speed)
    renderMilestonesChart(
      pullStart: progress.pull_start_time,
      pullFinish: progress.pull_finish_time,
      chunkerStart: progress.chunker_start_time,
      chunkerFinish: progress.chunker_start_time,
      tcoderStart: progress.tcoder_start_time,
      tcoderFinish: progress.tcoder_finish_time,
      mergerStart: progress.merger_start_time,
      mergerFinish: progress.merger_finish_time
    )

  vent.on 'job:finish', ->
    clearInterval(refresher)

  $('#detail-toggle').on('click', (e) ->
    e.preventDefault()
    $this = $(this)
    $this.text(if $this.text() == 'Show Details' then 'Hide Details' else 'Show Details')
    $('#details').slideToggle()
    false
  )





