if onJobsList() then $ ->

  App.Models.Job = Backbone.Model.extend({
    initialize: ->
      console.log('creating a model')
      return
  })

  App.Collections.Jobs = Backbone.Collection.extend
    model: App.Models.Job
    url: '/jobs.json'


  App.Views.JobsList = Backbone.View.extend
    tagName: 'table'
    className: 'twelve columns'
    initialize: ->
      this.$el.append('<tr> <th>Job ID</th> <th>Status</th> <th>Width</th> <th>Height</th> <th></th> <th></th> </tr>')
      this.collection.on('add', @addOne, this)
      return
    render: ->
      this.collection.each(@addOne, this)
      return this
    addOne: (job) ->
      jobView = new App.Views.Job({ model: job })
      this.$el.append(jobView.render().el)
      return

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

  App.Models.ProgressBar = Backbone.Model.extend
    initialize: ->
      console.log('creating a progressBar')
      return


  App.Views.ProgressBarsList = Backbone.View.extend
    tagName: 'div'
    initialize: ->
      this.collection.on('add', @createOne, this)
      return
    render: ->
      this.collection.each(@createOne, this)
      return this
    createOne: (progressBar) ->
      progressBarView = new App.Views.ProgressBar({ model: progressBar })
      this.$el.append(progressBarView.render().el)
      return

  App.Views.ProgressBar = Backbone.View.extend
    tagName: 'div'
    className: 'nice round progress twelve job-bar'
    template: template('progressBarTemplate')
    initialize: ->
      this.model.on('change', @render, this)
      return
    render: ->
      progressBarTemplate = @template(this.model.toJSON())
      @$el.html(progressBarTemplate)
      return this

  App.Collections.Progressions = Backbone.Collection.extend
    model: App.Models.ProgressBar
    url: '/jobs/progressions.json'



  jobsCollection = new App.Collections.Jobs()
  jobsCollection.fetch()
  jobsList = new App.Views.JobsList({ collection: jobsCollection })
  $('.jobs-div').html(jobsList.render().el)

  progressBarsCollection = new App.Collections.Progressions()
  progressBarsCollection.fetch()
  progressBarsList = new App.Views.ProgressBarsList({ collection: progressBarsCollection })
  $('.progress-bar').html(progressBarsList.render().el)
