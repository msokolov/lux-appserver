xquery version "1.0";

declare namespace local="http://luxdb.net/local";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

import module namespace http="http://expath.org/ns/http-client";
import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";

declare variable $lux:http as document-node() external;

declare function local:http-get ($url as xs:string)
  as document-node()
{
  let $request := <http:request method="get" href="{$url}" />
  let $response := http:send-request ($request)
  return $response[2]
};

declare function local:add-paths ($p1 as xs:string, $p2 as xs:string)
as xs:string
{
  if (ends-with($p1, "/")) then
    if (starts-with($p2, "/")) then
      concat($p1, substring($p2, 1))
    else
      concat ($p1, $p2)
  else
    if (starts-with($p2, "/")) then
      concat ($p1, $p2)
    else
      concat($p1, "/", $p2)
};

declare function local:read ($url as xs:string?)
{
  let $coll := if ($url) then local:http-get ($url) else ()
  let $body :=
  <body>
    <form action="read-exist.xqy" name="read" style="margin: 1em" method="post">
      <input type="text" name="url" value="{$url}" size="80" />
      <input type="submit" value="load" />
    </form>
      { 
      if ($coll) then
      <div>
        <script src="../js/jquery-1.8.2.min.js"></script>
        <script src="js/load-document.js"></script>
        <ul id="loader-report">
          <li>Loading {count($coll//exist:resource)} documents</li>
        </ul>
        <script>
        var urls_to_load = [ {
          for $resource in $coll//exist:resource
          return concat ('"', local:add-paths($url, $resource/@name), '",')
        }];
        var i;
        for (i = 0; i &lt; 20 &amp;&amp; urls_to_load.length > 0; i++)
          load_document (urls_to_load.shift(), urls_to_load);
        </script>
      </div>
    else ()
      }
  </body>
  return layout:outer("/read-exist.xqy", $body/*, $lux:http)
};

declare function local:main () 
{
  let $url := $lux:http/http/params/param[@name='url']/value/string()
  return local:read ($url)
};

local:main()