xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace util="http://falutin.net/connect4/util" at "util.xqy";

declare variable $lux:http as document-node() external;

declare function c4:place-circle (
  $game as element(c4:game), 
  $player as element(c4:player), 
  $col as xs:int)
{
  let $iplayer := count ($game/c4:players/c4:player[. << $player]) + 1
  let $inext := ($iplayer + 1) mod count($game/c4:players/c4:player)
  let $selected := ($game/c4:grid/c4:row/c4:cell[$col][empty(.)])[last()]
  return if (not($selected)) then util:error ("There's no space left in that column - try again") else
  let $updated-game := 
  <c4:game>{
    $game/@id, 
    attribute modified { current-dateTime() },
    <c4:players>{
      for $p at $i in $game/c4:players/c4:player
      return <c4:player>{
        $p/@color, 
        if ($i eq $inext) 
          then attribute active { "yes" } 
        else (),
          $p/node()
      }</c4:player>
    }</c4:players>,
    <c4:grid>{
      for $row in $game/c4:grid/c4:row return
      <c4:row>{
        for $cell in $row/c4:cell return
          if ($cell is $selected) 
            then <c4:cell>$player/@color/string()</c4:cell>
          else $cell
      }</c4:row>
    }</c4:grid>
  }</c4:game>
  let $insert := (
    lux:insert (concat('/connect4/', $game), $updated-game),
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
    if (not($player/@active eq "yes")) then util:error("Player not active")
  else
    if (not(number($col)) or xs:int($col) lt 1 or xs:int($col) gt count($game/c4:grid/c4:row[1]/c4:cell)) then util:error (concat("Invalid column: ", $col))
  else
    let $update := c4:place-circle ($game, $player, xs:int($col))
    return util:redirect (<a href="view.xqy?game={$game-id}&amp;player={$player-name}"/>/@href)
};

c4:play()