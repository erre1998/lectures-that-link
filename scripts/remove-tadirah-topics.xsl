<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math local" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:local="local"
  version="3.0">
  
  <!-- this script removes tadirah topics from the lecture series file -->
  
  <!--<xsl:output indent="yes"/>-->
  
  <xsl:template match="node() | @* | comment() | processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="term[@type='topics-tadirah']"/>
  
</xsl:stylesheet>