if onJobShow() then $ ->

  vent = _.extend({}, Backbone.Events)


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
        finished_template = template('finished-job-template')(@model.toJSON())
        $(@el).html(finished_template)
        @stopListening()
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
      console.log(data)
      percentage = (data.bytes / size) * 100
      if percentage > 100 then percentage = 100
      percentage = "#{percentage}%"
      $(this).find('.speed').html("Speed: #{data.speed}mbps")
      $(this).find('.meter').animate(width: percentage)


  vent.on 'job:finish', ->
    clearInterval(refresher)
    jobData = job.toJSON()
    bar_section = $('progress-bars')
    if (bar_section.length > 0)
      bar_section.html()
