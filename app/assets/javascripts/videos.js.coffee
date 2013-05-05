$ ->
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
