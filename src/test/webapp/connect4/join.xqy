xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";

declare variable $lux:http as document-node() external;

declare function c4:join-game()
{
  let $dtm := current-dateTime()
  let $name := $lux:http/http/params/param[@name='player']/value/string()
  let $game-id := $lux:http/http/params/param[@name='game']/value/string()
  let $game := collection()/c4:game[@id=$game-id]
  return
    if (not($game)) then c4:error("Game not found")
  else
    if (count($game/c4:players/c4:player) gt 1) then c4:error ("Game full")
  else
  let $insert := (
    lux:insert (concat('/connect4/', $dtm), $new-game),
    lux:commit())
  let $body := 
  <div>
    { $insert }
    New game created for { $name }
  </div>
  return layout:outer('/connect4/start.xqy', $body)
};

c4:join-game()