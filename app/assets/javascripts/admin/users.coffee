# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.search_user = (input) ->
  $.get "users?format=js",
    {search: input}

userlist = []

inSearch = false

$(document).on 'turbolinks:load', ->
  document.addEventListener 'userform:load', ->
    $('#username').on 'input', ->
      if this.value.length < 3
        $('#users').empty()
        inSearch = false
      else
        inSearch = true
        search_ldap(this)

addDropDownUser = (user)->
  elem = $("<p class='dropdown-item'>#{user.displayname}</p>")
  elem.on 'click', ->
    fillForm(user)

fillForm = (user)->
  $('#username').val(user.samaccountname)
  $('#email').val(user.mail)
  $('#displayName').val(user.displayname)

search_ldap = (context)->
  selected = $(context).attr 'user-selected'
  username = $(context).val();
  if username.length > 3 && selected == 'false'
    $.get "/admin/ldap",
      {
        format: "json",
        search: username,
      },
      (data)->
        $("#users").empty()
        userlist.length = 0
        data.map (user)->
          if inSearch
            userlist.push(user.myhash)
            $('#users').append addDropDownUser(user.myhash)

