xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace util="http://falutin.net/connect4/util" at "util.xqy";
import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";

declare variable $lux:http as document-node() external;

declare function c4:place-circle (
  $game as element(c4:game), 
  $player as element(c4:player), 
  $col as xs:int)
{
  (: should always = 1 :)
  let $iplayer := count ($game/c4:players/c4:player[. << $player]) + 1
  let $log := lux:log (count($game/c4:grid/c4:row/c4:cell[$col][empty(node())]), "info")
  let $selected := ($game/c4:grid/c4:row/c4:cell[$col][empty(node())])[last()]
  return if (not($selected or $log)) then util:error ("There's no space left in that column - try again") else
  let $updated-game := 
  <c4:game>{
    $game/@id, 
    attribute modified { current-dateTime() },
    (: shift player to the end of the queue :)
    <c4:players>{
      $game/c4:players/c4:player[not(position() eq $iplayer)],
      $player
    }</c4:players>,
    <c4:grid>{
      for $row in $game/c4:grid/c4:row return
      <c4:row>{
        for $cell in $row/c4:cell return
          if ($cell is $selected) 
            then <c4:cell>{$player/@color/string()}</c4:cell>
          else $cell
      }</c4:row>
    }</c4:grid>
  }</c4:game>
  let $insert := (
    lux:insert (concat('/connect4/', $game/@id), $updated-game),
    lux:commit())
  return $insert
};

declare function c4:play ()
{
  let $game-id := util:param ($lux:http, "game")
  let $game := collection()/c4:game[@id=$game-id]
  let $player-name := util:param ($lux:http, "player")
  let $player := $game/c4:players/c4:player[.=$player-name]
  let $col := util:param ($lux:http, "col")
  return
    if (not($game)) then util:error("Game not found")
  else
    if (not($player)) then util:error("Player not found")
  else
    if (not($player is $game/c4:players/c4:player[1])) then util:error("Player not active")
  else
    if (not(number($col)) or xs:int($col) lt 1 or xs:int($col) gt count($game/c4:grid/c4:row[1]/c4:cell)) then util:error (concat("Invalid column: ", $col))
  else
    let $update := c4:place-circle ($game, $player, xs:int($col))
    return util:redirect (<a href="view.xqy?game={$game-id, $update}&amp;player={$player-name}"/>/@href)
    (:return layout:outer ("play.xqy", <textarea rows="8" cols="132">{$update}</textarea>):)
};

c4:play()