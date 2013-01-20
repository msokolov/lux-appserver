<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lux="http://luxproject.net"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="http://local" 
                version="2.0">

  <xsl:param name="query" />

  <xsl:template match="/SCENE">
    <div class="scene">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="SPEECH">
    <ul class="speech">
      <li class="speech-info">
        <span class="speaker"><xsl:value-of select="local:capitalize(SPEAKER[1])" /></span>
      </li>
      <li>
        <xsl:apply-templates select="LINE" />
      </li>
    </ul>
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

  <xsl:template match="/LINE">
    <div class="line"><xsl:apply-templates /></div>
  </xsl:template>

</xsl:stylesheet>
