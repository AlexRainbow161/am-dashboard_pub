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
//= require jquery
//= require bootstrap.bundle
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require_tree ./admin

let patch_panel_event = new Event('patch_panel_load');
let photo_event = new Event('photo_form_load');
$(document).on('patch_panel_load', ()=>{
    patch_panel_load();
});
$(document).on('photo_form_load', ()=>{
   new_photo_form_load();
});

function goto(url) {
    document.location = url
}

function collapse_side_nav() {
    $sidenav = $('#sideNav');
    $container = $('#container');
    if ($sidenav.css('width') === '0px'){
        $sidenav.css('width', '20vw');
        $container.css('opacity', '.5')
    }
    else {
        $sidenav.css('width', '0');
        $container.css('opacity', '1')
    }
}

$(document).on('turbolinks:load', ()=>{
    patch_panel_load();
});

function patch_panel_load() {
    $('div.port').on('dblclick', (e)=>{
        $('#exampleModalCenter').modal('toggle');
        $('.modal-header').html(`<h5> Порт номер ${$(e.currentTarget).attr('data-port')}`);
        portId = $(e.currentTarget).attr('data-port-id');
        panelId = $('div.patch-panel').attr('data-panel-id');
        jobId = $('div.patch-panel').attr('data-job-id');
        $.get(`/jobs/${jobId}/patch_panels/${panelId}/ports/${portId}/edit`, {
            format: 'js'
        });
    });
}

function new_photo_form_load() {
    $('#customFile').on('change', function (e) {
        $('#previewFile').empty();
        $('#fileLabel').text(e.target.files[0].name);
        $('#previewFile').css('max-height', $('#formFields').height());
        $('#previewFile').append(`<img class="img-thumbnail" style="max-height: inherit" src="${URL.createObjectURL(e.target.files[0])}"></img>`);
    });
    $('#zoneSelect').change(function (e) {
        var zone_id = e.target.selectedOptions[0].value;
        $.get(
            '/staff',
            {format: 'js',
                zone_id: zone_id});});
}
