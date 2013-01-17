function validate() {
    if (! document.getElementById('player1').value) {
        alert ("you must enter a name to play");
        return false;
    } 
    return true;
}
