<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" />
  
  <xsl:template match="/">
    <html>
      <head>
        <!-- We apply this to XML in all browsers, but it's really essential
             for chrome, which doesn't provide a decent XML native mode -->
        <title>Lux XML Chrome Hack</title>
        <style type="text/css">
          body { font-family: arial, sans-serif; font-size: 10pt  }
          .xml-element { margin-left: 1em; }
          .tag { color: #226622; }
          .tag:hover { text-decoration: underline }
          .attr-name { color: #618; font-weight: normal }
          .attr-value { color: blue; font-style: italic }
          .collapsed { font-weight: bold; }
        </style>
      </head>
      <body id="body">
        <xsl:apply-templates>
          <xsl:with-param name="element-class" select="'xml-document'" />
        </xsl:apply-templates>
        <script src="../lux/js/jquery-1.8.2.min.js"></script>
        <script>
          $('#body').click(function(event) {
            var $target = $(event.target);
            if ($target.is(".tag")) {
              if ($target.hasClass("collapsed")) {
                // expand
                $target.removeClass("collapsed");
                $target.text ($target.text().substring(0,$target.text().length-3));
                $target.parent().contents().show();
              } else {
                // collapse
                $target.parent().contents().not($target).hide();
                $target.addClass("collapsed");
                $target.text ($target.text() + "...");
              }
            }
          });
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*">
    <xsl:param name="element-class" />
    <div class="{$element-class}">
      <span class="tag">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name(.)" />
        <xsl:apply-templates select="@*" />
        <xsl:text>&gt;</xsl:text>
      </span>
      <xsl:apply-templates>
          <xsl:with-param name="element-class" select="'xml-element'" />
      </xsl:apply-templates>
      <span class="tag">
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name(.)" />
        <xsl:text>&gt;</xsl:text>
      </span>
    </div>
  </xsl:template>

  <xsl:template match="text()">
    <!-- so we can use jQuery to hide/show -->
    <span><xsl:value-of select="." /></span>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:text> </xsl:text>
    <span class="attr-name">
      <xsl:value-of select="name(.)" />
    </span>
    <xsl:text>=</xsl:text>
    <span class="attr-value">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>"</xsl:text>
    </span>
  </xsl:template>

</xsl:stylesheet>
