xquery version "1.0";

module namespace util="http://falutin.net/connect4/util";

declare function util:formatDateTime ($dtm) 
  as xs:string 
{
  let $s := string($dtm)
  return concat (substring($s,6,5), ' ', substring($s, 12, 8))
};
