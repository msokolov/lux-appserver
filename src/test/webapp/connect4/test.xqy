xquery version "1.0";

declare namespace c4="http://falutin.net/connect4";

import module namespace util="http://falutin.net/connect4/util" at "util.xqy";
import module namespace layout="http://falutin.net/connect4/layout" at "layout.xqy";
import module namespace c4a="http://falutin.net/connect4/analysis" at "analysis.xqy";

declare variable $lux:http as document-node() external;

declare function c4:test ()
{
  let $game-id := util:param ($lux:http, 'game')
  let $game := collection()/game[@id=$game-id]
  let $checked-game := c4a:check-game ($game)
  let $winner := c4a:compute-winner ($game)
  let $cell := c4a:get-cell ($game, 6, 1)
  let $check00 := c4a:check-cell ($game, 6, 1, $cell, 1, <dir x="1" y="0" />)
  let $check01 := c4a:check-cell ($game, 6, 1, $cell, 1, <dir x="1" y="0" />)
  return layout:outer('/connect4/test.xqy', 
    (c4a:draw-grid ($game),
    <textarea rows="24" cols="80">{ 
    $checked-game, "&#10;.", $winner, "&#10;.", $check00, "&#10;.", $check01
                                  } </textarea>
                ))
};


c4:test()