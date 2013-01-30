xquery version "1.0";

declare namespace lux="http://luxdb.net";
declare namespace demo="http://luxdb.net/demo";

import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";
import module namespace search="http://luxdb.net/search" at "search-lib.xqy";

declare variable $lux:http as document-node() external;

declare function demo:get-document ($path)
as document-node()?
{
    if (doc-available ($path)) 
    then doc($path) 
    else
        if (starts-with ($path, "/")) 
        then doc (substring($path, 2)) 
        else ()
};
 
declare function demo:get-document ($query, $pos, $sort)
as document-node()?
{
    subsequence(lux:search ($query, (), $sort), $pos, 1)
};

declare function demo:search-at-pos ($pos, $params)
{
    let $ps := $params[not(@name=('start','pos','index','total'))]
    let $kvs := for $p in $ps return concat($p/@name,"=",$p/value)
    return concat ("/index.xqy?start=", $pos, "&amp;", string-join($kvs, "&amp;")) 
};

declare function demo:view ()
{
    let $enq as xs:string := $lux:http/http/params/param[@name='enq']/string()
    let $qs as element(param)* := search:decode-query ($enq)
    let $query := search:query ($qs)
    let $pos := (xs:integer($lux:http/http/params/param[@name='pos']), ($qs[@name='start'],1)[1] + $qs[@name='index']- 1)[1] 
    let $last := xs:integer($qs[@name='total']/value)
    let $pagination := <div id="pagination">{
        "results:", $pos,
        if ($pos gt 1) then <a href="/view.xqy?pos={$pos - 1}&amp;enq={$enq}"><b>&#x2190;</b> previous</a> else (),
        <a href="{demo:search-at-pos($pos,$qs)}">&#x21b0; back</a>,
        if ($pos lt $last) then <a href="/view.xqy?pos={$pos + 1}&amp;enq={$enq}">next <b>&#x2192;</b></a> else ()
    }</div>
    let $path := $lux:http/http/path-info
    let $sort := $qs[@name='sort']
    let $doc := if ($path) then demo:get-document ($path) else demo:get-document ($query, $pos, $sort)
    let $doctype := name($doc/*)
    let $stylesheet-name := concat("file:view-", $doctype, ".xsl")
    let $parts := 
        if (doc-available ($stylesheet-name)) then
            lux:transform (doc($stylesheet-name), lux:highlight ($query, $doc), ("query", $query))
        else
            (<h3>{$doctype}</h3>,<textarea cols="80" rows="12">{$doc}</textarea>)
    return layout:outer ('/view.xqy', (), ($pagination, $parts[1])) 
};

demo:view()