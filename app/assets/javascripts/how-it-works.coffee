HowItWorks =
  tabs: ["upload", "convert", "view"]

  activeTab: null

  setTabListeners: ->
    $.each @tabs, (i, tab) ->
      $(".nav-bar a." + tab).bind "click", (e) ->
        @activateTab tab
        e.preventDefault()

  activate: (tabClass) ->
    $(tabClass).addClass "active"

  deactivate: (tabClass) ->
    $(tabClass).removeClass "active"

  activateTab: (newTab) ->
    if @activeTab is newTab
      return
    else
      @activeTab = newTab

    # Make newTab active and remove active class from all the others tabs
    $.each @tabs, (i, tab) ->
      (if (tab is newTab) then @activate("." + newTab) else @deactivate("." + tab))

    # Show text of newTab
    @showDescription newTab

  showDescription: (newTab) ->
    unless $(".description." + newTab).is(":visible")
      $(".description:visible").fadeOut 200, ->
        $(".description." + newTab).fadeIn 200

  setImageListeners: ->
    $(".d-image").click (e) ->
      tabClass = @id.replace("image-", "")
      HowItWorks.activateTab tabClass
      false

$ ->
  HowItWorks.setTabListeners()
  HowItWorks.setImageListeners()
