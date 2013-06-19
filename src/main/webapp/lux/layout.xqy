module namespace layout = "http://luxdb.net/demo/layout";

import module namespace config="http://luxdb.net/demo/config" at "config.xqy";

declare function layout:render-nav ($current-url as xs:string)
{
let $nav := (
  <item url="index.xqy">search</item>, 
  <item url="query.xqy">query</item>, 
  <item url="read-ibiblio.xqy">load shakespeare</item>
)
return <div><ul class="hlist">{
  for $item in $nav 
  return if ($item/@url eq $current-url) 
    then <li class="selected">{$item/string()}</li>
  else <li><a href="{$item/@url}">{$item/string()}</a></li>
}</ul></div>
};

declare function layout:outer ($current-url as xs:string, $body as node()*, $http as document-node(element(http))) 
{
    layout:outer($current-url, $body, (), $http)
};

declare function layout:outer ($current-url as xs:string, $body as node()*, $header as node()*, $http as document-node( element(http))) 
{
<html>
  <head>
    <title>Lux Demo</title>
    <link href="{config:path('styles.css', $http)}" rel="stylesheet" />
    <script src="{config:path('js/jquery-1.8.2.min.js', $http)}"></script>
  </head>
  <body>
    <div id="masthead">
      <h1 class="logo">
        <a href="index.xqy">
          <img class="logo" src="{config:path('img/sunflwor52.png', $http)}" alt="Lux" height="40" border="0" /> Lux Demo
        </a>
      </h1>
      { layout:render-nav ($current-url), $header}
    </div>
    <div id="main">{
      $body
    }</div>
  </body>
</html>
};
