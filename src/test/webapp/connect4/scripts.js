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

function activateClick ()
{
    $('.circle').bind("click", onClick);
}

function updateTurnState () 
{
    if ($('#turn').attr('active') == 'true') {
        activateClick();
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
        intervalTimer = undefined
    }
    $.ajax({
        dataType: 'text', url: url,
    }).done(function (data) {
        console.log ("get-current returns " + data);
        if (data && data == $('#player').val()) {
            // BLINK!
            location.reload();
            // $('#turn').html("<div active='true'><blink>It's your turn now</blink><div class='circle'></div></div>");
            // enableClickEvent() ;
        } else {
            // console.log ("waitForTurn in 2000");
            intervalTimer = setInterval (waitForTurn, 2000);
        }
    });
}

/** jQuery setup onLoad handler **/
$(onLoad);
