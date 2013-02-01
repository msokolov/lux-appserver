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

function updateTurnState () 
{
    if ($('#turn').attr('active') == 'true') {
        $('.circle').bind("click", onClick);
    } else {
        waitForTurn ();
    }
}

function waitForTurn() {
    var url = 'get-current.xqy?game=' + $('#game').val();
    console.log (url);
    $.ajax({
        dataType: 'text', url: url,
    }).done(function (data) {
            console.log ("get-current returns " + data);
            if (data == $('#player').val()) {
                // BLINK!
                $('#turn').html("<div active='true'><blink>It's your turn now</blink><div class='circle'></div></div>");
                updateTurnState();
            } else {
                console.log ("waitForTurn in 5000");
                //setInterval (waitForTurn, 5000);
            }
    });
}

/** jQuery setup onLoad handler **/
$(onLoad);
