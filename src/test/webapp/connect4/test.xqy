module namespace test = "http://luxdb.net/test";

declare function test:test ($current-url as xs:string)
{
let $nav := (
  <item url="/connect4/">home</item>
)
return <div><ul class="hlist">{
  for $item in $nav 
  return if ($item/@url eq $current-url) 
    then <li class="selected">{$item/string()}</li>
  else <li><a href="{$item/@url}">{$item/string()}</a></li>
}</ul></div>
};
