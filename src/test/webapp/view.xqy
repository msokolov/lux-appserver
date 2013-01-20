xquery version "1.0";

declare namespace lux="http://luxproject.net";
declare namespace demo="http://luxproject.net/demo";

import module namespace layout="http://luxproject.net/demo/layout" at "layout.xqy";

declare variable $lux:http as document-node() external;

let $path := $lux:http/http/path-info
let $doc := if (doc-available ($path)) then doc($path) else
  if (starts-with ($path, "/")) then doc (substring($path, 2)) else ()
let $doctype := name($doc/*)
let $stylesheet-name := concat("file:view-", $doctype, ".xsl")
return
  if (doc-available ($stylesheet-name)) then
    layout:outer ('/view.xqy', lux:transform (doc($stylesheet-name), $doc))
  else
    layout:outer ('/view.xqy', <textarea cols="80" rows="12">{$doc}</textarea>)

