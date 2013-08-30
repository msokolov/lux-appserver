function load_document (url, more_urls) {
    'use strict';
    // $('#loader-report').append ("<li>Loading " + url + "</li>");
    $.ajax({
        url: 'load-document.xqy?url=' + url,
        // async: false,
        // dataType: 'html'
    }).done(function (data) {
        $('#loader-report').append (data);
        $('#loader-report').trigger ('create');
    }).fail(function(xhr, status, error) {
        $('#loader-report').append 
        ("<li>An error occurred while loading'" +
         url
         + "': " + error + "</li>");
    }).always(function(){
        if (more_urls.length > 0) {
            load_document (more_urls.shift(), more_urls);
        }
    });
}
