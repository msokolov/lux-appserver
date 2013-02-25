xquery version "1.0";

declare namespace local="http://luxdb.net/local";

import module namespace layout="http://luxdb.net/demo/layout" at "../layout.xqy";

declare function local:rseed ()
{
  (current-dateTime() - xs:dateTime("1970-01-01T00:00:00-00:00"))
  div xs:dayTimeDuration('PT1S')
};

(: Return a list with the next seed to pass, and the random integer 
in the range 1-$range, inclusive :)
declare function local:rand ($seed as xs:integer, $range as xs:integer) 
  as xs:integer+
{
  let $r as xs:integer := (69069*$seed + 1) mod 4294967296
  return if ($range eq 0) then (1, $r) else ($r mod $range + 1, $r)
};

declare function local:generate-next-word ($word, $length, $seed)
{
  let $nspeech := count (lux:search($word))
  let $r := local:rand ($seed, $nspeech)
  let $speech := (lux:search($word))[$r[1]]
  let $hilited := lux:highlight($word, $speech)
  let $nwords := count ($hilited//B)
  let $r1 := local:rand ($r[2], $nwords)
  let $next-node := $hilited/descendant::B[$r1[1]]/following-sibling::node()[1]
  let $next-word := tokenize($next-node, "\s+")[matches(., "\w")][1]
(:  return ($nspeech, $nwords, $next-word, count($next-word))  :)
  return if ($next-word) then
    local:generate ($next-word, $length - 1, $r1[2]) 
  else if ($length gt 0) then (
    if ($nspeech gt 5) then
      local:generate-next-word ($word, $length - 1, $r1[2]) 
    else
      local:generate-next-word (local:randword()[1], $length - 1, $r1[2])
  ) else ()
};

declare function local:generate ($word, $length, $seed)
{
  if ($length gt 0 and $word) then 
    ($word, local:generate-next-word (concat('"', $word, '"'), $length, $seed))
  else
    $word
};

declare function local:randword ()
{
  let $nspeech := count (collection())
  let $r := local:rand (local:rseed(), $nspeech)
  let $words := tokenize (collection()[$r[1]], "\s+")
  let $nwords := count ($words)
  let $r1 := local:rand ($r[2], $nwords)
  let $seed as xs:integer := $r1[2]
  let $word as xs:string := $words[$r1[1]]
  return ($word, $seed)
};

declare function local:speech () 
{
  let $r1 := local:randword()
  let $word as xs:string := $r1[1]
  let $seed as xs:integer := $r1[2]
  let $r2 := local:rand ($seed, 100)
  let $blog := local:generate ($word, $r2[1] + 100, $seed)
  return $blog
};

declare function local:main () 
{
  layout:outer("/randblog/speech.xqy", <p>{local:speech()}</p>)
(:
  let $nspeech := count (collection()/SPEECH)
  let $r := local:rand (local:rseed(), $nspeech)
  return <div><p>{subsequence(collection()/SPEECH,$r[1],1)//LINE}</p><p>{$r[1]}</p></div>
:)
};

local:main()
