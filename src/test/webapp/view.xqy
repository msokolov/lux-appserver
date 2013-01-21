xquery version "1.0";

declare namespace lux="http://luxproject.net";
declare namespace demo="http://luxproject.net/demo";

import module namespace layout="http://luxproject.net/demo/layout" at "layout.xqy";
import module namespace search="http://luxproject.net/search" at "search-lib.xqy";

declare variable $lux:http as document-node() external;

declare function demo:get-document () 
as  document-node()?
{
    let $path := $lux:http/http/path-info
    if ($path) then
        if (doc-available ($path)) then doc($path) else
            if (starts-with ($path, "/")) then doc (substring($path, 2)) else ()
    else
        (: search :)
}

let $enq as xs:string := $lux:http/http/params/param[@name='enq']/string()
let $qs as element(param)* := search:decode-query ($enq)
let $query := search:query ($qs)
let $index := ($qs[@name='start']/value,1)[1] + $qs[@name='index']/value - 1 
let $last := xs:integer($qs[@name='total']/value)
let $pagination := <div id="pagination">{
    if ($index gt 1) then <a href="/view.xqy?index={$index - 1}&amp;enq={$enq}">previous</a> else (),
    <a href="">search results</a>, " ",
    if ($index lt $last) then <a href="/view.xqy?index={$index + 1}&amp;enq={$enq}">next</a> else ()
}</div>
let $doc := demo:get-document ()
let $doctype := name($doc/*)
let $stylesheet-name := concat("file:view-", $doctype, ".xsl")
let $body := 
  if (doc-available ($stylesheet-name)) then
    lux:transform (doc($stylesheet-name), lux:highlight ($query, $doc), ("query", $query))
  else
    <textarea cols="80" rows="12">{$doc}</textarea>
return 
    layout:outer ('/view.xqy', ($pagination, $body)) 
