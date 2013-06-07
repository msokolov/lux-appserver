<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lux="http://luxdb.net"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="http://local" 
                version="2.0">

  <xsl:param name="query" />
  <xsl:param name="enquery" />
  
  <xsl:template match="/SPEECH">
    <div class="play-info">
      <div class="speech">
        <span>
          <xsl:variable name="url" select="replace(base-uri(/), '/[^/]+$', '')" />
          <xsl:variable name="title">
            <xsl:choose>
              <xsl:when test="$query and $query != '*:*'">
                <xsl:sequence select="lux:highlight(., $query)/descendant::B[1]/.." />
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="LINE[1]/node()" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <a href="view.xqy?uri={$url}&amp;enq={$enquery}#speech{@speech}"><xsl:copy-of select="$title" /></a>
          <xsl:if test="LINE[2]"> ...</xsl:if>
        </span>
      </div>
      <div class="speech-info">
        <span class="speaker"><xsl:value-of select="local:capitalize(SPEAKER[1])" /></span>
        <span class="source"><xsl:value-of select="@play" /></span>
        <span class="locator"><xsl:value-of select="@act" />;<xsl:value-of select="@scene" /></span>
      </div>
    </div>
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

</xsl:stylesheet>
