module namespace config = "http://luxdb.net/demo/config";

declare function config:path ($path, $req as document-node(element(http))) {
    concat($req/http/context-path, "/lux/", $path) 
};