xquery version "1.0";

module namespace util="http://falutin.net/connect4/util";

declare function util:redirect ($path as xs:string)
  as element(html)
{
<html>
  <head>
    <meta http-equiv="refresh" content="0;URL={$path}" />
    <script>location.href="{$path}"</script>
  </head>
  <body>
    If your browser does not redirect, 
    <a href="{$path}">click here</a>.
  </body>
</html>
};

declare function util:error ($message as xs:string)
{
  util:redirect (concat ("index.xqy?error=", $message))
};

declare function util:param ($http, $name as xs:string)
  as xs:string?
{
  $http/http/params/param[@name=$name]/value/string()
};

declare function util:formatDateTime ($dtm) 
  as xs:string 
{
  let $s := string($dtm)
  return concat (substring($s,6,5), ' ', substring($s, 12, 8))
};

