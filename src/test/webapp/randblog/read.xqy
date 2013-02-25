xquery version "1.0";

declare namespace local="http://luxdb.net/local";
declare namespace html="http://www.w3.org/1999/xhtml";

import module namespace http="http://expath.org/ns/http-client";
import module namespace layout="http://luxdb.net/demo/layout" at "../layout.xqy";

declare variable $lux:http as document-node() external;

declare function local:http-get ($url as xs:string)
  as document-node()
{
  let $request := <http:request method="get" href="{$url}" />
  let $response := http:send-request ($request)
  return $response[2]
};

declare function local:read ($url as xs:string?)
{
  let $html := if ($url) then local:http-get ($url) else ()
  let $body :=
  <body>
    <form action="read.xqy" name="read" style="margin: 1em" method="post">
      <input type="text" name="url" value="{$url}" />
      <input type="submit" value="go" />
      { if ($url) then (
        <input type="button" value="(de)select all" onclick="$('.selection').prop('checked', ! $('.selection')[0].checked)" />,
        <ul id="search-results">{
          <li><input type="checkbox" name="selection" class="selection" value="{$url}" checked="checked" /> {$url}</li>,
          for $r in $html//html:a
          return <li><input type="checkbox" name="selection" class="selection" value="{resolve-uri( $r/@href, $url)}" checked="checked" /> {$r/string()}</li>
        }</ul>,
        <input type="submit" name="load" value="load selected" 
             onclick="document.forms.read.action='../load.xqy'; return true" />,
        <input type="button" value="(de)select all" onclick="$('.selection').prop('checked', ! $('.selection')[0].checked)" />
      ) else ()
      }
    </form>
    <script src="../js/jquery-1.8.2.min.js"></script>
  </body>
  return layout:outer("/randblog/read.xqy", $body/*)
};

declare function local:main () 
{
  let $url := $lux:http/http/params/param[@name='url']/value/string()
  return local:read ($url)
};

local:main()