xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace util="http://falutin.net/connect4/util" at "util.xqy";

declare variable $lux:http as document-node() external;

declare function c4:game-add-user($game as element(game), $name as xs:string)
  as element(game)
{
  let $active := not($game/players/player/@active="yes")
  return
  <game>{
    $game/@id, 
    attribute modified { current-dateTime() },
    <players>{
      $game/players/player,
      <player color="#ff0">{
        if ($active) then attribute active {"yes"} else (),
        $name
      }</player>
    }</players>,
    $game/grid
  }</game>
};

declare function c4:join-game()
{
  let $dtm := current-dateTime()
  let $name := util:param ($lux:http, 'player')
  let $game-id := util:param($lux:http, 'game')
  let $game := collection()/game[@id=$game-id]
  return
    if (not($game)) then util:error("Game not found")
  else
    if (not($name)) then util:error("Player name cannot be blank")
  else
    if (count($game/players/player) gt 1) then util:error ("Game full")
  else
    let $updated-game := c4:game-add-user ($game, $name)
    let $insert := (
      lux:insert (concat('/connect4/', $game-id), $updated-game),
      lux:commit())
      let $body := 
      <div>
        { $insert }
        Player {$name} joined;  
        <a href="view.xqy?game={$game-id}&amp;player={$name}">Proceed to game.</a>
      </div>
      return layout:outer('/connect4/start.xqy', $body)
};

c4:join-game()
