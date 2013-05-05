if onJobsList() then $ ->
  console.log('executing jobsList backbone')
  App.Models.Job = Backbone.Model.extend({
    initialize: ->
      console.log('creating a job model')
      return
  })

  App.Collections.Jobs = Backbone.Collection.extend
    model: App.Models.Job
    url: '/jobs'
    comparator: (job) ->
      return -job.get("id")

  App.Views.Job = Backbone.View.extend
    tagName: 'tr'
    template: template('jobDetailsTemplate')
    json: ''
    initialize: ->
      this.json = this.model.toJSON()
      return
    render: (checkBoxValue) ->
      jobTemplate = @template(this.json)
      @$el.html(jobTemplate).attr('id', 'row-'+this.json.id )
      checkBox = @$el.find('input:checkbox:first')
      if checkBoxValue == true
        checkBox.attr('checked', 'checked')
      else
        checkBox.removeAttr('checked')
      return this

  App.Models.ProgressBar = Backbone.Model.extend
    initialize: ->
      console.log('creating a progressBar')
      return

  App.Views.JobsList = Backbone.View.extend
    tagName: 'tbody'
    initialize: ->
      this.collection.on('change', @render, this)
      this.collection.on('add', @addOne, this)
      return
    render: ->
      this.collection.each(@addOne, this)
      return this
    addOne: (job) ->
      jobJSON = job.toJSON()
      jobID = jobJSON.id
      checkBoxValue = $('#checkbox-'+jobID).prop('checked')
      jobView = new App.Views.Job({ model: job })
      $('#row-'+jobID).remove()
      this.$el.append(jobView.render(checkBoxValue).el)
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

  jobsCollection = new App.Collections.Jobs()
  jobsCollection.fetch().then(
    jobsList = new App.Views.JobsList({ collection: jobsCollection })
    $('#jobs-table').append(jobsList.render().el)
  )

  refresher = setInterval ->
    jobsCollection.fetch()
    console.log("fetching for jobsCollection")
  , 2500

  $ ->
    $("#select_all").click (event) ->
      if @checked
        $(":checkbox").each ->
          @checked = true
      else
        $(":checkbox").each ->
          @checked = ""
