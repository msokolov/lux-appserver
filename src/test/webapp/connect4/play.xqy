xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace util="http://falutin.net/connect4/util" at "util.xqy";
import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace c4a="http://falutin.net/connect4/analysis" at "analysis.xqy";

declare variable $lux:http as document-node() external;

declare function c4:place-circle (
  $game as element(game), 
  $player as element(player), 
  $col as xs:int)
as element (game)
{
  (: should always = 1 :)
  let $iplayer := count ($game/players/player[. << $player]) + 1
  let $log := lux:log (count($game/grid/row/cell[$col][empty(node())]), "info")
  let $selected := ($game/grid/row/cell[$col][empty(node())])[last()]
  return if (not($selected or $log)) then <game status="error">There's no space left in that column - try again</game> else
  let $updated-game := 
  <game>{
    $game/@id, 
    attribute modified { current-dateTime() },
    (: shift player to the end of the queue :)
    <players>{
      $game/players/player[not(position() eq $iplayer)],
      $player
    }</players>,
    <grid>{
      for $row in $game/grid/row return
      <row>{
        for $cell in $row/cell return
          if ($cell is $selected) 
            then <cell>{$player/@color/string()}</cell>
          else $cell
      }</row>
    }</grid>
  }</game>
  let $checked-game := c4a:check-game ($updated-game)
  let $insert := (
    lux:insert (concat('/connect4/', $game/@id), $checked-game),
    lux:commit())
  return ($updated-game, lux:log(($insert,"hey")[1], "info"))
};

declare function c4:fezzik ($game)
{
  let $cell := ($game//cell[.=''])[1]
  let $col := count ($cell/preceding-sibling::cell) + 1
  return c4:place-circle ($game, $game/players/player[1], $col)
};

declare function c4:bot-play ($game)
{
  let $bot := $game/players/player[1]
  where $bot = ("fezzik")
  return c4:fezzik ($game)
};

declare function c4:play-turn(
  $game as element(game), 
  $player as element(player), 
  $col as xs:int)
{
  let $new-game := c4:place-circle ($game, $player, xs:int($col))
  let $next-game-state := c4:bot-play ($new-game)
  let $url := <a href="view.xqy?game={$game/@id}&amp;player={$player}&amp;error={$next-game-state[@status='error']}"/>/@href
  return $url
};

declare function c4:play ()
{
  let $game-id := util:param ($lux:http, "game")
  let $game := collection()/game[@id=$game-id]
  let $player-name := util:param ($lux:http, "player")
  let $player := $game/players/player[.=$player-name]
  let $col := util:param ($lux:http, "col")
  return
    if (not($game)) then util:error("Game not found")
  else
    if (not($player)) then util:error("Player not found")
  else
    if (not($player is $game/players/player[1])) then util:error("Player not active")
  else
    if (not(number($col)) or xs:int($col) lt 1 or xs:int($col) gt count($game/grid/row[1]/cell)) then util:error (concat("Invalid column: ", $col))
  else
    let $url := c4:play-turn ($game, $player, xs:int($col))
    return util:redirect ($url)
};

c4:play()