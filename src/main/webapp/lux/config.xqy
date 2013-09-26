module namespace config = "http://luxdb.net/demo/config";

declare namespace http="http://expath.org/ns/webapp";

declare function config:path ($path, $req as document-node()) {
    if ($req/http) then
        concat($req/http/context-path, "/lux/", $path) 
    else
        concat($req/http:request/http:context-root, "/lux/", $path) 
};

