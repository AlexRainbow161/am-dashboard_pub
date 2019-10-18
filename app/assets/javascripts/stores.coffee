# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.search_store = (input)->
  $.get "stores",
    {
      format: "js",
      name: input
    }