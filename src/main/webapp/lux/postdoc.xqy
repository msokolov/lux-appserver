xquery version "1.0";

declare namespace demo="http://luxdb.net/demo";
declare namespace http="http://expath.org/ns/webapp";

import module namespace config="http://luxdb.net/demo/config" at "config.xqy";
import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";
import module namespace search="http://luxdb.net/search" at "search-lib.xqy";

declare variable $http:input external;


declare function demo:handle-post() 
{
  if ($http:input/http:request/http:body) then
     (lux:insert ("/test.xml", $http:input[2]), lux:commit(), "file saved")
  else
     "select a file to post"
};

  let $parts := (
    demo:handle-post (),
    <h3>Post a Document</h3>,
    <p>Got request with {count($http:input)} parts</p>,
    <form action="postdoc.xqy" enctype="multipart/form-data" method="post">
        Browse: <input name="file" type="file" /> <input type="submit" />
    </form>,
    <textarea cols="80" rows="8">{
      $http:input
    }</textarea>
  )
  return layout:outer ('/postdoc.xqy', (), ($parts), $http:input[1]) 
