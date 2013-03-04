xquery version "1.0";

declare namespace demo="http://luxdb.net/demo";

import module namespace layout="http://luxdb.net/demo/layout" at "layout.xqy";

declare variable $lux:http as document-node() external;

(: Query Tool :)

(: load any JS files here - they'll go at the end of the body :)
declare function demo:javascript-postamble() {
  <div>
    <script src="js/jquery-1.8.2.min.js"></script>
    <script src="js/query-history.js"></script>
    <script src="js/chrome-xml-iframe-hack.js"></script>
  </div>
};

declare function demo:main () {
  let $params := $lux:http/http/params/param 
  let $query := $params[@name='query']/value/string()
  let $body := 
  <body>
    <div id="editor">
      <div id="left">
        <ol id="query-history">
        </ol>
      </div>
      <div id="right">
        <form action="/solr/xquery" id="search" name="search" method="post" target="results">
          <input type="hidden" name="wt" value="lux" />
          <input type="hidden" name="lux.content-type" value="text/xml" />
          <input type="hidden" name="lux.xml-xsl-stylesheet" value="/chrome-xml.xsl" />
          <textarea id="q" name="q" cols="80" rows="10">{$query}</textarea>
          <br/>
          <input type="submit" value="go" />   
          (use ctrl-Enter)
          <input type="button" value="save" onclick="saveQuery()" />
          (max 10)
        </form>
      </div>
    </div>
    <iframe id="results" name="results">
    </iframe>
    { demo:javascript-postamble () }
  </body>/*

  return layout:outer('/query.xqy', $body)
};

demo:main ()
