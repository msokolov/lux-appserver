xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace util="http://falutin.net/connect4/util" at "util.xqy";
import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace c4a="http://falutin.net/connect4/analysis" at "analysis.xqy";

declare variable $lux:http as document-node() external;

declare function c4:play-turn(
  $game as element(game), 
  $player as element(player), 
  $col as xs:int)
{
  let $new-game := c4a:place-circle ($game, $player, xs:int($col))
  let $next-game-state := c4a:bot-play ($new-game)
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