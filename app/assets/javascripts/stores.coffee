# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.search_store = (input)->
  debounceSearch input
  return
search = (value) ->
  $.get "stores",
    format: "js"
    name: value
  return

debounceSearch = _.debounce search, 300
