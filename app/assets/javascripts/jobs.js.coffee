if onJobsList() then $ ->

  vent = _.extend({}, Backbone.Events)

  App.Models.Job = Backbone.Model.extend({
    initialize: ->
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
      vent.trigger(
        'progress:change',
        jobJSON.id,
        jobJSON.status.pull,
        jobJSON.status.transcode,
        jobJSON.video.size
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

  $ ->
    $("#select_all").click (event) ->
      if @checked
        $(":checkbox").each ->
          @checked = true
      else
        $(":checkbox").each ->
          @checked = ""
