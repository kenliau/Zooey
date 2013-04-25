if onJobShow() then $ ->
  console.log('onJobShow function is called')

  vent = _.extend({}, Backbone.Events)


  class Job extends Backbone.Model
    urlRoot: '/jobs'


  class JobView extends Backbone.View
    el: '#job-table-body'
    initialize: ->
      @listenTo(@model, 'change', @render)
      return
    template: template('job-template')
    render: =>
      current_job = @model.toJSON()
      debugger
      if (current_job.finished_at?)
        $(@el).html(@template(current_job))
        vent.trigger('job:finish')
        @stopListening
      return this


      return this


  job = new Job id: onJobShow()
  window.ja = job
  jobView = new JobView model: job


  refresher = setInterval ->
    job.fetch()
    console.log("called")
  , 2500

  vent.on('job:finish', -> clearInterval(refresher))

