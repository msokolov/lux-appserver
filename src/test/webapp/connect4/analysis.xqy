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
