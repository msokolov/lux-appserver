declare namespace file="http://expath.org/ns/file";
declare namespace demo="http://luxdb.net/demo";

import module namespace config="http://luxdb.net/demo/config" at "config.xqy";
import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";
import module namespace http="http://expath.org/ns/http-client";

declare variable $lux:http as document-node() external;

declare function demo:expand-selection ($selected as xs:string*)
as xs:string*
{
  for $url in $selected
  return if (file:is-dir($url)) then
    demo:expand-selection (for $f in file:list ($url) return concat($url, "/", $f))
  else 
    $url
};

declare function demo:load ()
as node()*
{
  let $selection := $lux:http/http/params/param[@name='selection']/value/string()
  let $urls := demo:expand-selection ($selection)
  return 
  <div>
    <ul id="loader-report">
      <li>Loading {count($urls)} documents</li>
    </ul>
    <script src="{$config:root-url}js/jquery-1.8.2.min.js"></script>
    <script src="{$config:root-url}js/load-document.js"></script>
    <script>{
      for $url in $urls
      return concat("load_document('", $url, "');&#10;")
    }</script>
  </div>
};

let $erase-all := ($lux:http/http/params/param[@name='erase-all']='yes')
let $result := if ($erase-all) then
  <p>Erase all not yet supported</p>
else
  demo:load()
return layout:outer ('/', $result)
