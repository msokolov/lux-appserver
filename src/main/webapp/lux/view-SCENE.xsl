<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lux="http://luxdb.net"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="http://local" 
                version="2.0">

  <xsl:param name="query" />

  <xsl:template match="/SCENE">
    <!-- <h3><xsl:value-of select="$query" /></h3> -->
    <xsl:apply-templates select="TITLE"/>
    <div class="scene">
      <xsl:apply-templates select="TITLE/following-sibling::node()"/>
    </div>
  </xsl:template>
 
  <xsl:template match="TITLE">
    <h2>
      Act 
      <xsl:value-of select="local:roman(/SCENE/@act)"/>,
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
     </h2>
  </xsl:template>
 
  <xsl:template match="STAGEDIR">
    <blockquote><xsl:apply-templates /></blockquote>
  </xsl:template>
  
  <xsl:template match="SPEECH">
    <div class="speech-container" id="speech{@speech}">
      <div class="speaker">
        <xsl:value-of select="local:capitalize(SPEAKER[1])" />
      </div>
      <div class="speech">
        <xsl:apply-templates select="LINE" />
      </div>
    </div>
  </xsl:template>
  
  <xsl:template match="B">
    <span class="hi"><xsl:apply-templates /></span>
  </xsl:template>

  <xsl:function name="local:capitalize">
    <xsl:param name="string" />
    <xsl:variable name="words" as="xs:string*">
      <xsl:for-each select="tokenize($string, ' ')">
        <xsl:value-of select="concat(upper-case(substring(.,1,1)),lower-case(substring(.,2)))" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="string-join($words, ' ')" />
  </xsl:function>

  <xsl:template match="LINE">
    <div class="line" id="@line"><xsl:apply-templates /></div>
  </xsl:template>

  <xsl:function name="local:roman">
    <xsl:param name="num" />
    <xsl:value-of select="('I','II','III','IV','V','VI','VII','VIII','IX','X')[position()=$num]" />
  </xsl:function>
  
</xsl:stylesheet>
