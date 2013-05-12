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

window.onVideosList = ->
  path == '/videos' or path == '/videos/'

window.onJobsList = ->
  path == '/jobs' or path == '/jobs/'

window.onVideoNew = ->
  path == '/videos/new' or path == '/videos/new/'

# Prevent browser from caching ajax requests
$.ajaxSetup
  cache: false

window.readablizeBytes = (bytes) ->
  s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB']
  e = Math.floor(Math.log(bytes) / Math.log(1024))
  (bytes / Math.pow(1024, Math.floor(e))).toFixed(2) + " " + s[e]

