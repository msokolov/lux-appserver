xquery version "1.0";

declare variable $lux:http as document-node() external;

let $path := $lux:http/http/path-info
return doc(concat ("lux:/", $path))
