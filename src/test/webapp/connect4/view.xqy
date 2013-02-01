xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace util="http://falutin.net/connect4/util" at "util.xqy";

declare variable $lux:http as document-node() external;

declare function c4:players($game as element(game), $user as element(player)?) {
  for $player at $i in $game/players/player
    let $color := attribute style {"background: ", $player/@color }
    let $pdisplay := 
      if ($i eq 1) then <i>{$color, $player/string()}</i> 
      else <span>{$color, $player/string()}</span>
  let $p := if ($user) then $pdisplay else 
  <a href="view.xqy?game={$game/@id}&amp;player={$player}">{$pdisplay}</a>
  return if ($i eq 1) then $p else (" vs. ", $p)
};

    (:
    lux:transform (<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"><xsl:template match="@*"><xsl:value-of select="format-dateTime(., '[M01]/[D01]/[Y0001] [h]:[m]')" /></xsl:template></xsl:stylesheet>,
    :)

declare function c4:main() {
  let $game-id := util:param ($lux:http, 'game')
  let $game := collection()/game[@id=$game-id]
  let $winner := $game/@winner
  let $player-name := util:param($lux:http, 'player')
  let $players := $game/players/player
  let $player := $players[.=$player-name]
  let $active := if (count($players) gt 1) then $game/players/player[1] else ()
  let $error := util:param($lux:http, "error")
  let $body := 
  <div>
    <h2>Game: {c4:players ($game, $player), " started at ", util:formatDateTime($game-id)}
    </h2>
    <div>{if ($error) then <p class="error">{$error}</p> else ()}</div>
    <form action="play.xqy" method="post" name="play">
      <input type="hidden" id="player" name="player" value="{$player-name}" />
      <input type="hidden" id="game" name="game" value="{$game-id}" />
      <input type="hidden" id="col" name="col" value="" />
    </form>
    <table class="c4grid">{
      for $row in $game/grid/row
      return <tr>{
      for $cell at $i in $row/cell return
      <td class="circle" col="{$i}">{
        let $color := $cell/string()
        where $color 
        return attribute style { concat ("background: ", $color, ";") }
      }</td>
      }</tr>
    }</table>
    <div id="turn">{
      if ($winner) then
        concat ($players[@color = $winner], " wins!")
      else if ($player is $active) then
        (attribute active { "true" }, <blink>Your turn</blink> )
      else if ($active) then
        concat($active, "'s turn")
      else
        "Waiting for some competition to show up"
    }</div>
    <p>player={$player} active={$active}
    </p>
    <textarea rows="8" cols="132">{$game}</textarea>
    <script src="../js/jquery-1.8.2.min.js"></script>
    <script src="scripts.js"></script>
  </div>
  return layout:outer('/connect4/view.xqy', $body)
};

c4:main()
