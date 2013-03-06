/*
 * localStorage['lux-query-history-size'] 
 * localStorage['lux-query-history-{N}'] 
 * store the queries in forward order, but display them in reverse order.
 * 
 */

/*
 * select the nth query from storage, and mark it as selected
 */
function selectQuery (n) {
    var q = getQuery (n);
    if (q) {
        setCurrentQuery (n);
        $('#q').val (q);
        $('#q').focus();
    }
}

function setCurrentQuery (n) {
    console.log ("setCurrentQuery " + n);
    console.log (" found " + $('#query-history>li').length + " existing queries");
    var count = getQueryCount ();
    $('#query-history>li').removeClass('selected');
    console.log (" ther are " + $('#query-history li').length + " queries now");
    console.log (" selecting query " + $('#query-history>li').eq(count - n - 1).length);
    $('#query-history>li').eq(count - n - 1).addClass('selected');
}

function saveQuery () {
    console.log ("saveQuery(): adding new query");
    var q = $('#q').val();
    // add new
    var n = localStorage['lux-query-history-size'];
    if (n >= 10) {
        deleteQuery (0);
        --n;
    }
    setQuery (n, q);
    insertQueryMenu (n, q);
    setCurrentQuery (n);
}

function updateQuery () {
    // update an existing query
    console.log ("updateQuery()");
    var q = $('#q').val();
    var selection = $('#query-history>li.selected');
    var i = selection.index();
    var count = getQueryCount();
    // update the menu
    $('#query-history>li.selected>a').eq(0).text (formatQuery(q));
    // update the stored query
    setQuery (count - i - 1, q);
}

function formatQuery (q) {
    var pieces = q.split(";");
    return pieces[pieces.length-1].substring(0, 20);
}

function setQuery (n, q) {
    console.log ("setQuery " + n);
    var count = localStorage['lux-query-history-size'];
    if (n >= count) {
        localStorage['lux-query-history-size'] = parseInt(n) + 1;
    }
    return localStorage["lux-query-history-" + n] = q;
}

function getQuery (n) {
    return localStorage["lux-query-history-" + n];
}

function getQueryCount () {
    return parseInt (localStorage['lux-query-history-size']);
}

function deleteQuery (n) {
    delete localStorage["lux-query-history-" + n];
    populateQueryHistory();
}

/*
 * insert a new query at the head of the menu, numbered i
 */
function insertQueryMenu (i, q) {
    $('#query-history').prepend 
        ('<li>' + 
         '<a href="javascript:void(0)" onclick="selectQuery(' + i + ')">' + 
         formatQuery(q) + 
         '</a>' + 
         /*
         '<a class="delete-query" href="javascript:void(0)" onclick="deleteQuery(' + i + ')">' + 
         " x" +
         '</a>' + 
         */
         '</li>');
}

function populateQueryHistory () {
    $('#query-history').children().remove();
    var n = getQueryCount();
    console.log ("populate " + n);
    /** get all the queries, put them in an array, and store them again.
        This way we can clean out any gaps or weirdness that may have occurred
        since local storage is not an array or anything.
    */
    var queries = [];
    var j = 0;
    for (var i = 0; i < n; i++) {
        var q = getQuery (i);
        delete localStorage['lux-query-history-' + i];
        if (q && j < 10) {
            queries[j++] = q;
        }
    }
    localStorage['lux-query-history-size'] = 0;
    for (i = 0; i < queries.length; i++) {
        q = queries[i];
        setQuery (i, q);
        insertQueryMenu (i, q);
    }
}

$('#search').submit(function(event) {
    updateQuery ();
});

$('#q').keydown(function(event) {
    var keyCode = event.keyCode;
    // console.log ("key=" + keyCode);
    if ((keyCode == 13 || keyCode == 10) && event.ctrlKey) {
        // console.log ("detected ctrl-Enter");
        updateQuery(); // event not triggered by artifical submission
        document.forms.search.submit();
    } 
});

$('#q').focus();

populateQueryHistory();
if (queries.length > 0) {
    selectQuery (queries.length-1);
}
