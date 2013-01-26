module namespace layout = "http://falutin.net/connect4/layout";

declare function layout:outer ($current-url as xs:string, $body as node()*) 
{
<html>
  <head>
    <title>Connect4/falutin.net</title>
    <link href="styles.css" rel="stylesheet" />
  </head>
  <body>
    <h1>
      <a href="/connect4/">
        <img class="logo" src="/connect4/connect4.jpg" alt="Lux" height="40" /> Connect 4
      </a>
    </h1>
    <div id="main">{
      $body
    }</div>
  </body>
</html>
};
