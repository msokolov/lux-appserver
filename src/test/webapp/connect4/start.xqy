xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";

declare variable $lux:http as document-node() external;

declare function c4:new-game($name as xs:string, $dtm as xs:dateTime)
{
  <c4:game modified="{$dtm}" id="{$dtm}">
    <c4:players>
      <c4:player current="yes" color="#f00">{$name}</c4:player>
    </c4:players>
    <c4:grid>{
      for $i in 1 to 7 return
        <c4:row>{
          for $j in 1 to 7 return
            <c4:cell />
        }</c4:row>
    }</c4:grid>
  </c4:game>
};

declare function c4:start-game()
{
  let $dtm := current-dateTime()
  let $name := $lux:http/http/params/param[@name='player1']/value/string()
  let $new-game := c4:new-game ($name, $dtm)
  let $insert := (
    lux:insert (concat('/connect4/', $dtm), $new-game),
    lux:commit())
  let $body := 
  <div>
    { $insert }
    New game created for { $name }; <a href="view.xqy?game={$dtm}&amp;player={$name}">proceed to game</a>
  </div>
  return layout:outer('/connect4/start.xqy', $body)
};

c4:start-game()