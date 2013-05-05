# Backbone and Underscore initialization
window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

_.templateSettings =
  interpolate: /\{\{\=(.+?)\}\}/g
  evaluate: /\{\{\%(.+?)\}\}/g
  escape : /\{\{-(.+?)\}\}/g

window.template = (id) ->
  _.template $('#' + id).html()


# Detecting path location
path = window.location.pathname

window.onJobShow = ->
  /\/jobs\/[0-9]+/.test(path) and parseInt(path.split('/')[2], 10)

window.onJobsList = ->
  path == '/jobs'


# Prevent browser from caching ajax requests
$.ajaxSetup
  cache: false
