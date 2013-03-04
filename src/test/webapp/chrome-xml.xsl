<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Lux XML Chrome Hack</title>
        <style type="text/css">
          body { font-family: arial, sans-serif; font-size: 10pt  }
          .element { margin-left: 1em; }
          .tag { color: #226622;  }
          .attr-name { color: #618; font-weight: normal }
          .attr-value { color: blue; font-style: italic }
        </style>
      </head>
      <body>
        <xsl:apply-templates>
          <xsl:with-param name="element-class" select="'top'" />
        </xsl:apply-templates>
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
          <xsl:with-param name="element-class" select="'element'" />
      </xsl:apply-templates>
      <span class="tag">
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name(.)" />
        <xsl:text>&gt;</xsl:text>
      </span>
    </div>
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
