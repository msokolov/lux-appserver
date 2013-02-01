function onLoad () {
    updateTurnState ();
}

function onClick (event) {
    var col = $(event.target).attr("col");
    $('#col').val(col);
    document.forms.play.submit();
    //$('play').submit();
}

function validate() {
    if (! $('#player1').val()) {
        alert ("you must enter a name to play");
        return false;
    } 
    return true;
}

function enableClickEvent () {
    $('.circle').bind("click", onClick);
}

function updateTurnState () 
{
    if ($('#turn').attr('active') == 'true') {
        enableClickEvent ();
    } else {
        waitForTurn ();
    }
}

var intervalTimer;

function waitForTurn() {
    var url = 'get-current.xqy?game=' + $('#game').val();
    console.log (url);
    if (intervalTimer) {
        clearInterval (intervalTimer);
    }
    $.ajax({
        dataType: 'text', url: url,
    }).done(function (data) {
            console.log ("get-current returns " + data);
            if (data == $('#player').val()) {
                // BLINK!
                location.reload();
                // $('#turn').html("<div active='true'><blink>It's your turn now</blink><div class='circle'></div></div>");
                // enableClickEvent() ;
            } else {
                console.log ("waitForTurn in 5000");
                intervalTimer = setInterval (waitForTurn, 1000);
            }
    });
}

/** jQuery setup onLoad handler **/
$(onLoad);
