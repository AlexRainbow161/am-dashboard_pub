App.events = App.cable.subscriptions.create "EventsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("div.event-menu").prepend(data['message'])
    if data['event_count'] > 0
      $eventBadge =  $("#event-badge");
      $eventBadge.removeClass('d-none')
      $eventBadge[0].innerText = data['event_count']
      $eventsContainer = $('.events-container');
      if $eventsContainer.length > 0
        $eventsContainer.prepend $(data['message']).removeClass('event-card').attr('data-context', 'index')
      $('#audioPlay').trigger('click');
