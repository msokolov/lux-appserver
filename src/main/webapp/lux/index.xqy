xquery version "1.0";

declare namespace demo="http://luxdb.net/demo";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

import module namespace config="http://luxdb.net/demo/config" at "config.xqy";
import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";
import module namespace search="http://luxdb.net/search" at "search-lib.xqy";

declare variable $lux:http as document-node() external;

(: Search Page :)

declare function demo:search-results ($query, $start as xs:integer, $page-size as xs:integer, $sort as xs:string?, $total as xs:integer)
{
  for $doc at $index in subsequence(lux:search ($query, $sort), $start, $page-size)
  let $doctype := name($doc/*)
  let $stylesheet-name := concat("file:", $doctype, "-result.xsl")
  let $enquery := search:encode-query(($lux:http/http/params/param, 
    <param name="total"><value>{$total}</value></param>,
    <param name="index"><value>{$index}</value></param>
    )) 
  let $result-markup := 
    if (doc-available ($stylesheet-name)) then
      lux:transform (doc($stylesheet-name), $doc, ("query", $query, "enquery", $enquery))
    else
      let $uri := base-uri ($doc)
      let $absuri := if (starts-with($uri, "/")) then $uri else concat ("/", $uri)
      return demo:snippet($doc, $absuri, $query, $enquery)
    return <li>{$result-markup}</li>
};

declare function demo:snippet ($doc as node(), $uri as xs:string, $q as xs:string, $enquery as xs:string)
  as node()
{
  let $title := ($doc/descendant::title/string(),$uri)[1]
  let $hl := lux:highlight ($doc, $q)
  let $match := $hl/descendant::B[1]
  let $length := (80 - string-length($match)) div 2
  let $left-text := demo:snip-left ($match, $length)
  let $right-text := demo:snip-right ($match, $length)
  return
  <div>
    <a href="view.xqy?uri={$uri}&amp;enq={$enquery}">{$title}</a>
    <div class="speech">{
      $left-text, $match, $right-text
    }</div>
  </div>
};

(: get $length text immediately to the left of (preceding) $node TODO:
accept a list of element names that should introduce white space :)

declare function demo:snip-left($node as node()?, $length)
  as xs:string
{
  let $prev := $node/preceding::text()[1]
  return if ($prev) then
    let $plen := string-length($prev)
    return 
      if ($plen gt $length) then
        concat("...", substring ($prev, string-length($prev) - $length + 1, $length))
      else if ($plen eq $length) then
        if ($prev/preceding::text()) then
          concat("...", $prev)
        else
          $prev/string()
      else
        concat (demo:snip-left($prev, $length - $plen), $prev/string())
  else ""
};

declare function demo:snip-right($node as node()?, $length)
  as xs:string
{
  let $next := $node/following::text()[1]
  return if ($next) then
    let $plen := string-length($next)
    return 
      if ($plen gt $length) then
        concat(substring ($next, 1, $length), "...")
      else if ($plen eq $length) then
        if ($next/following::text()) then
          concat($next, "...")
        else
          $next/string()
      else
        concat ($next/string(), demo:snip-right($next, $length - $plen))
  else ""
};

declare function demo:search ($params as element(param)*, $start as xs:integer, $page-size as xs:integer)
{
    let $sort := $params[@name='sort']/value/string()
    let $query := search:query ($params)
    let $total := if ($query) then lux:count ($query) else 0
    return
    <search-results total="{$total}">{
        if ($query) then demo:search-results ($query, $start, $page-size, $sort, $total) else ()
    }</search-results>
};

declare function demo:search () {
let $page-size := 20
let $params := $lux:http/http/params/param 
let $start as xs:integer := if (number($params[@name='start'])) then xs:integer($params[@name='start']) else 1
let $results := demo:search ($params, $start, $page-size)
let $next := $start + count($results/*)
let $body := 
  <body>
    <form action="index.xqy" id="search" name="search">
      { search:search-controls ($params) }
      { search:search-description ($start, $results/@total, $next, $params) }
    </form>
    <ul id="search-results">{$results/*}</ul>
    { search:search-pagination ($start, $results/@total, $next, $page-size) }
    <div class="indent-body">
      <br/>
      <input type="button" value="erase all" onclick="javascript:if (confirm('Are you sure you want to irretrievably delete the entire contents of your database?')) location.href='delete-all.xqy'" />
    </div>
    { search:javascript-postamble ($lux:http) }
    {
      let $qname := $params[@name='qname'] where not ($qname) return
      <script>$("#qname").focus()</script>
    }
  </body>/*

return layout:outer('/index.xqy', $body, $lux:http)
};

demo:search()
