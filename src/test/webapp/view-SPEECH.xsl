<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:lux="http://luxdb.net"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="http://local" 
                version="2.0">

  <xsl:import href="view-SCENE.xsl" />

  <xsl:param name="query" />
  
  <xsl:template match="/SPEECH">
    <!--  get the scene in which this speech appears as="document-node(element(SCENE))"  -->
    <xsl:variable name="scene" as="document-node(element(SCENE))" select="doc(replace(base-uri(.), '/[^/]+$', ''))" />
    <xsl:apply-templates select="lux:highlight($query, $scene)" />
    <script src="js/jquery-1.8.2.min.js"></script>
    <script>
      $(function () {
        location.hash = "#<xsl:value-of select="concat('speech',@speech)" />";
      });
    </script>
  </xsl:template>

</xsl:stylesheet>
