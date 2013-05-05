if onVideosList() then $ ->
  class VideoModel extends Backbone.Model
    initialize: ->
      return
  
  class VideoCollection extends Backbone.Collection
    model: VideoModel
    url: '/videos'
    comparator: (video) ->
      return -video.get("id")

  class VideoView extends Backbone.View
    tagName: 'li'
    template: template('videoDetailsTemplate')
    json: ''
    initialize: ->
      this.json = this.model.toJSON()
      return
    render: (checkBoxValue) ->
      videoTemplate = @template(this.model.toJSON())
      @$el.html(videoTemplate).attr('id', 'row-'+this.json.id)
      checkBox = @$el.find('input:checkbox:first')
      if checkBoxValue == true
        checkBox.attr('checked', 'checked')
      else
        checkBox.removeAttr('checked')
      return this

  class VideoListView extends Backbone.View
    tagName: 'ul'
    className: 'accordion'
    initialize: ->
      this.collection.on('add', @addOne, this)
      this.collection.on('change', @render, this)
      return
    render: ->
      this.collection.each(@addOne, this)
      return this
    addOne: (video) ->
      videoJSON = video.toJSON()
      videoID = videoJSON.id
      checkBoxValue = $('#checkbox-'+videoID).prop('checked')
      videoView = new VideoView({model: video})
      $('#row-'+videoID).remove()
      this.$el.append(videoView.render(checkBoxValue).el)
      return

  videosCollection = new VideoCollection()
  videosCollection.fetch().then(
    videosList = new VideoListView({ collection: videosCollection })
    $('#videos-table').append(videosList.render().el)
  )

  refresher = setInterval ->
    videosCollection.fetch()
  , 2500

  $ ->
    $("#select_all").click (event) ->
      if @checked
        $(":checkbox").each ->
          @checked = true
      else
        $(":checkbox").each ->
          @checked = ""


if onVideoNew() then $ ->
  video_file = $('#video_video_file')
  video_url = $('#video_location')
  video_file.change ->
    if(video_file.val() == '')
      video_url.attr("disabled", false)
    else
      video_url.attr("disabled", "disabled")
    return

  video_url.focus ->
    video_file.attr("disabled", "disabled")

  video_url.blur ->
    if(video_url.val() == '')
      video_file.attr("disabled", false)

  video_url.change ->
    if(video_url.val() != '')
      video_file.attr("disabled", "disabled")

  return
