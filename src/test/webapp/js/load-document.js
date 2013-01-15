function load_document (url) {
    'use strict';
    // $('#loader-report').append ("<li>Loading " + url + "</li>");
    $.ajax({
        url: 'load-document.xqy?url=' + url,
        // async: false,
        dataType: 'html'
    }).done(function (data) {
        $('#loader-report').append (data);
        $('#loader-report').trigger ('create');
    });
}
