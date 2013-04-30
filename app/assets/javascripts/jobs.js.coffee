if onJobsList() then $ ->

  vent = _.extend({}, Backbone.Events)

  App.Models.Job = Backbone.Model.extend({
    initialize: ->
      return
  })

  App.Collections.Jobs = Backbone.Collection.extend
    model: App.Models.Job
    url: '/jobs'


  App.Views.Job = Backbone.View.extend
    tagName: 'tr'
    template: template('jobDetailsTemplate')
    initialize: ->
      this.model.on('change', @render, this)
      return
    render: ->
      jobTemplate = @template(this.model.toJSON())
      @$el.html(jobTemplate)
      return this

  App.Views.JobsList = Backbone.View.extend
    tagName: 'tbody'
    initialize: ->
      this.collection.on('change', @render, this)
      this.collection.on('add', @addOne, this)
      return
    render: ->
      this.$el.empty()
      this.collection.each(@addOne, this)
      return this
    addOne: (job) ->
      current_job = job.toJSON()
      jobView = new App.Views.Job({ model: job })
      this.$el.append(jobView.render().el)
      vent.trigger(
        'progress:change',
        current_job.id,
        current_job.status.pull,
        current_job.status.transcode,
        current_job.video.size
      )
      return



  jobsCollection = new App.Collections.Jobs()
  jobsCollection.fetch().then(
    jobsList = new App.Views.JobsList({ collection: jobsCollection })
    $('#jobs-table').append(jobsList.render().el)
  )

  refresher = setInterval ->
    jobsCollection.fetch()
  , 3000


  progressBars = $('.progress')

  vent.on 'progress:change', (id, pull, transcode, size) ->
    $('.progress').each ->
      data = if $(this).hasClass('pull-progress-bar') then pull else transcode
      percentage = (data.bytes / size) * 100
      if percentage > 100 then percentage = 100
      percentage = "#{percentage}%"
      $(this).find("##{id}-meter").css(width: percentage)

