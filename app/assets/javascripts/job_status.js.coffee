if onJobShow() then $ ->

  vent = _.extend({}, Backbone.Events)

  # ChartJS
  renderSizeChart = (originalSize, outputSize) ->
    chartElement = $("#sizeChart")
    if chartElement.length < 1 or chartElement.hasClass('rendered') then return
    chartElement.addClass('rendered')

    outputSize ||= parseInt(chartElement.data('output-size'), 10)
    originalSize ||= parseInt(chartElement.data('original-size'), 10)
    console.log(outputSize, originalSize)
    ctx = chartElement.get(0).getContext("2d")
    data = [
      value: outputSize
      color: "#67bf95"
    ,
      value: originalSize
      color: "#22c9e3"
    ]
    sizeChart = new Chart(ctx).Doughnut(data,
      { onAnimationComplete : ->
          ctx.font = "bold 12px sans-serif"
          ctx.fillStyle = "#22c9e3"
          ctx.fillText("Original Size", 140, 250)
          ctx.font = "bold 12px sans-serif"
          ctx.fillStyle = "#67bf95"
          ctx.fillText("Output Size", 200, 150)
      }
    )

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
    console.log(data)
    polarChart = new Chart(ctx).PolarArea(data)

  renderSizeChart()
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
      $(this).find('.speed').html("Speed: #{data.speed}mbps")
      $(this).find('.meter').animate(width: percentage)


  vent.on 'job:finish', ->
    clearInterval(refresher)
    jobData = job.toJSON()
    progress = jobData.progression
    renderSizeChart(jobData.video.size, jobData.output_size)
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

  $('#detail-toggle').on('click', (e) ->
    e.preventDefault()
    $this = $(this)
    $this.text(if $this.text() == 'Show Details' then 'Hide Details' else 'Show Details')
    $('#details').slideToggle()
    false
  )
