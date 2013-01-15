declare namespace file="http://expath.org/ns/file";
declare namespace demo="http://luxproject.net/demo";

import module namespace http="http://expath.org/ns/http-client";

declare variable $lux:http as document-node() external;

declare function demo:load-from-http ($url as xs:string)
  as document-node()
{
  let $request := <http:request method="get" href="{$url}" />
  let $response := http:send-request ($request)
  return $response[2]
};

declare function demo:load-url ($url as xs:string)
as xs:string*
{
    let $doc as document-node()? := if (starts-with($url, "http:")) then
      demo:load-from-http ($url)
    else if (starts-with ($url, "file:")) then
      doc ($url)
    else
      doc (concat("file:", $url))
    let $doctype as xs:string := name($doc/*)
    let $load-xsl as xs:string := concat ("file:", $doctype, "-load.xsl")
    return if (doc-available ($load-xsl)) then
      demo:transform-load ($doc, doc($load-xsl))
    else
      demo:default-load ($doc)
};

declare function demo:transform-load ($doc as document-node(), $xsl as document-node())
  as xs:string
{
    let $basename := replace($doc/base-uri(), "^.*/(.*)\.xml", "$1")
    let $uri := concat ("/", $basename, ".xml")
    let $transformed := lux:transform ($xsl, $doc, ("uri-base", $basename))
    return (lux:insert ($uri, $transformed), $uri)
};

declare function demo:default-load ($doc as document-node())
  as xs:string
{
    let $basename := replace($doc/base-uri(), "^.*/(.*)\.xml", "$1")
    return
    for $e at $i in $doc/*/* 
    let $uri := concat ($basename, "-", $i, ".xml")
    return (lux:insert ($uri, $e), $uri)
};

declare function demo:load-document ()
  as node()*
{
  let $url := $lux:http/http/params/param[@name='url']/value/string()
  let $loaded := demo:load-url ($url)
  return <li>Loaded {count($loaded)} documents from { $url, lux:commit() }</li>
};

demo:load-document()
