xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace util="http://falutin.net/connect4/util" at "util.xqy";

declare variable $lux:http as document-node() external;

declare function c4:main() {
  let $id := $lux:http/http/params/param[@name='id']/value/string()
  let $game := collection()/c4:game[@id=$id]
  let $body := 
  <div>
    <h2>Game: {string-join ($game/c4:players/c4:player, ' vs. '), ' ', 
    util:formatDateTime($id)}
    </h2>
    <table class="c4grid">{
      for $row in $game/c4:grid/c4:row
      return <tr>{
      for $cell in $row/c4:cell return
        <td class="circle">{
          let $color := $game/c4:players/c4:player[.=$cell]/@color
          where $color 
          return attribute style { "background: {$color};" }
        }</td>
      }</tr>
    }</table>
    <script src="scripts.js"></script>
  </div>
  return layout:outer('/connect4/view.xqy', $body)
};

c4:main()
