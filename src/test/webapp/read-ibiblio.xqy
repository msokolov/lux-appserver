xquery version "1.0";

declare namespace local="http://luxdb.net/local";
declare namespace html="http://www.w3.org/1999/xhtml";

import module namespace http="http://expath.org/ns/http-client";
import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";

declare function local:read-ibiblio ()
{
  let $url := "http://www.ibiblio.org/xml/examples/shakespeare/"
  let $request := <http:request method="get" href="{$url}" />
  let $response := http:send-request ($request)
  let $html as document-node(element(html:html)) := $response[2]
  let $body :=
  <body>
    <form action="load.xqy" style="margin: 1em" method="post">
      <input type="submit" value="load selected plays" />
      <input type="button" value="(de)select all" onclick="$('.selection').prop('checked', ! $('.selection')[0].checked)" />
      <ul id="search-results">{
        for $r in $html//html:ul//html:a
        return <li><input type="checkbox" name="selection" class="selection" value="{resolve-uri( $r/@href, $url)}" checked="checked" /> {$r/string()}</li>
      }</ul>
    </form>
    <script src="js/jquery-1.8.2.min.js"></script>
  </body>
  return layout:outer("/read-ibiblio.xqy", $body/*)
};

local:read-ibiblio()
