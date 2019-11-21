# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on "turbolinks:load", ->
  $("body").on 'change', '#customFile', (e) ->
    $("#previewFile").empty
    $('#fileLabel').text e.target.files[0].name
    $('#previewFile').css 'max-height', $('#formFields').height
    $('#previewFile').append "<img class='img-thumbnail' style='max-height: inherit' src='#{URL.createObjectURL(e.target.files[0])}'></img>"
  $('body').on 'change', "#zoneSelect" ,  (e) ->
    zone_id = e.target.selectedOptions[0].value
    $.get '/staff',
      format: 'js'
      zone_id: zone_id
    return
