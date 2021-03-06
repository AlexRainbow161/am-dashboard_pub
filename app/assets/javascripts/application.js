// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require lodash
//= require jquery
//= require bootstrap.bundle
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require_tree ./admin


function remove_event_from_dropdown(eventId, unreadedEvents){
    $eventCard = $(`#event-card-${eventId}`);
    if ($eventCard.length > 0){
        $eventCard.remove();
    }
    $eventBadge = $('#event-badge');
    if (unreadedEvents < 1){
        $eventBadge.addClass('d-none');
    }
    else{
        $eventBadge[0].innerText = unreadedEvents;
    }

}

let lastRequest;

function storeLastRequest(request){
    lastRequest = request;
}

function getLastRequest(){
    return lastRequest;
}

$(document).on('turbolinks:load', ()=>{
   $('body').on('click', '#audioPlay', ()=>{
       $('#notifySound')[0].play();
   });
});
