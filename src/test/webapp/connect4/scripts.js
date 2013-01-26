function onLoad () {
    if ($('#turn').attr('active') == 'true') {
        $('.circle').bind("click", onClick);
    }
}

function onClick (event) {
    var col = $(event.target).attr("col");
    $('#col').val(col);
    document.forms.play.submit();
    //$('play').submit();
}

function validate() {
    if (! $('player1').value) {
        alert ("you must enter a name to play");
        return false;
    } 
    return true;
}

$(onLoad);
