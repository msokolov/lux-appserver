<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:html="http://www.w3.org/1999/xhtml"
                version="2.0">

  <xsl:param name="uri-base" />

  <xsl:template match="/">
    <xsl:apply-templates select="//html:body" />
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="html:script|html:SCRIPT|html:style|html:STYLE" />
 
</xsl:stylesheet>
