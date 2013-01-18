xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace util="http://falutin.net/connect4/util" at "util.xqy";

declare variable $lux:http as document-node() external;

declare function c4:players($game as element(c4:game), $user as element(c4:player)?) {
  for $player at $i in $game/c4:players/c4:player
  let $p := if ($user) then string($player) else 
  <a href="view.xqy?game={$game/@id}&amp;player={$player}">{string($player)}</a>
  return if ($i eq 1) then $p else (" vs. ", $p)
};

    (:
    lux:transform (<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"><xsl:template match="@*"><xsl:value-of select="format-dateTime(., '[M01]/[D01]/[Y0001] [h]:[m]')" /></xsl:template></xsl:stylesheet>,
    :)

declare function c4:main() {
  let $game-id := util:param ($lux:http, 'game')
  let $game := collection()/c4:game[@id=$game-id]
  let $player-name := util:param($lux:http, 'player')
  let $player := $game/c4:players/c4:player[.=$player-name]
  let $active := $game/c4:players/c4:player[@current="yes"]
  let $body := 
  <div>
    <h2>Game: {c4:players ($game, $player), " started at ", util:formatDateTime($game-id)}
    </h2>
    <form action="play.xqy" method="post" name="play">
      <input type="hidden" name="player" value="{$player-name}" />
      <input type="hidden" name="game" value="{$game-id}" />
      <input type="hidden" id="col" name="col" value="" />
    </form>
    <table class="c4grid">{
      for $row in $game/c4:grid/c4:row
      return <tr>{
      for $cell at $i in $row/c4:cell return
      <td class="circle" col="{$i}">{
        let $color := $game/c4:players/c4:player[.=$cell]/@color
        where $color 
        return attribute style { "background: {$color};" }
      }</td>
      }</tr>
    }</table>
    <div id="turn">{
      if ($player is $active) then
        (attribute active { "true" }, "Your turn" )
      else concat($active, "'s turn")}</div>
    <script src="../js/jquery-1.8.2.min.js"></script>
    <script src="scripts.js"></script>
  </div>
  return layout:outer('/connect4/view.xqy', $body)
};

c4:main()
