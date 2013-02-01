xquery version "1.0";

module namespace c4a="http://falutin.net/connect4/analysis";

declare variable $c4a:dirs as element(dirs) := <dirs>
  <dir x="1" y="0" />,
  <dir x="0" y="1" />,
  <dir x="1" y="-1" />,
  <dir x="1" y="1" />
</dirs>;

declare function c4a:get-cell ($game, $row, $col)
{
  $game/grid/row[$row]/cell[$col]
};

declare function c4a:check-cell ($game as element(game), $row, $col, $cell, $len, $dir)
  as xs:string?
{
  if ($len = 4)
    then $cell
  else 
    let $y1 := $row + $dir/@y
    let $x1 := $col + $dir/@x
    let $nabor := c4a:get-cell ($game, $y1, $x1)
    return 
      if ($nabor = $cell and string($cell))
        then c4a:check-cell ($game, $y1, $x1, $nabor, $len + 1, $dir)
      else
        ()
};

declare function c4a:compute-winner ($game as element(game))
{
  for $row in (1 to 7), $col in (1 to 6), $dir in $c4a:dirs//dir
  let $cell := c4a:get-cell ($game, $row, $col)
  return c4a:check-cell ($game, $row, $col, $cell, 1, $dir)
};

declare function c4a:check-game ($game as element(game))
  as element(game)
{
  let $winner := c4a:compute-winner ($game)
  return 
    if (count($winner) > 0) then
      <game  winner="{$winner[1]}">{$game/@*, $game/*}</game>
    else 
      $game
};

declare function c4a:draw-grid ($game as element(game)?)
{
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
};

declare function c4a:place-circle (
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



declare function c4a:fezzik ($game)
{
  let $cell := ($game//cell[.=''])[1]
  let $col := count ($cell/preceding-sibling::cell) + 1
  return c4a:place-circle ($game, $game/players/player[1], xs:int($col))
};

declare function c4a:is-bot($player)
{
  $player = ("fezzik")
};

declare function c4a:bot-play ($game)
{
  let $bot := $game/players/player[1]
  where c4a:is-bot($bot)
  return c4a:fezzik ($game)
};

