module namespace config = "http://luxdb.net/demo/config";

(:
  We cannot make relative paths work in any reasonable way
  since Solr expects a core name as the first path element
  (as in /core1/lux/index.xqy) for "handlers", but *not* for
  static assets.

  This path should only be used for static assets:
:)
declare variable $config:root-url as xs:string := "/lux/";
