xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace util="http://falutin.net/connect4/util" at "util.xqy";

declare variable $lux:http as document-node() external;

(: Connect 4 Game :)
    
declare function c4:list-game ($game as element(game)) {
<li>
  <a href="view.xqy?game={$game/@id}">{
    string-join ($game/players/player, ' vs. '),
    $game/@id/string()
  }</a>
  {
    if (not($game/@complete)) 
      then
      <form action="join.xqy" style="display:inline">
        <input type="submit" value="join as" />
        <input type="hidden" name="game" value="{$game/@id}" />
        <input type="text" name="player" size="10" />
      </form>
    else
      $game/@complete/string()
      (:format-dateTime($game/@id, '[M01]/[D01]/[Y0001] [H]:[M]', 'en'):)
      (:,<textarea>{$game}</textarea>:)
  }
</li>
};

declare function c4:main() {
  let $error := util:param($lux:http, "error")
  let $body := 
  <div>
    <div>{if ($error) then <p class="error">{$error}</p> else ()}</div>
    <form action="start.xqy" onsubmit="return validate()">
    Start a new game as player: 
    <input type="text" name="player1" id="player1" />
    <input type="submit" />
    </form>
    <h2>Games</h2>
    {
      if (not(collection()/game)) then <p>There are no existing games</p> else
      <ul>{
        for $game in collection()/game order by $game/@modified descending
        return c4:list-game ($game)
      }</ul>
    }
    <input type="button" value="erase all" onclick="javascript:if (confirm('Are you sure you want to irretrievably delete the entire contents of your database?')) location.href='delete-all.xqy'" />
    <script src="scripts.js"></script>
  </div>
  return layout:outer('/connect4/index.xqy', $body)
};

c4:main()
