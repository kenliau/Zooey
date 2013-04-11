if onJobShow() then $ ->

  vent = _.extend({}, Backbone.Events)

  class Job extends Backbone.Model
    urlRoot: '/jobs'

  class JobView extends Backbone.View
    initialize: ->
      @listenTo(@model, 'change', @show)
      return
    template: template('job-template')
    show: =>
      job = @model.toJSON()
      if (job.finished_at?) then vent.trigger('job:finish')
      @render
    render: =>
      console.log(@model.toJSON())
      return this


  job = new Job id: onJobShow()
  window.ja = job
  jobView = new JobView model: job


  refresher = setInterval ->
    job.fetch()
    console.log("called")
  , 2500

  vent.on('job:finish', -> clearInterval(refresher))

