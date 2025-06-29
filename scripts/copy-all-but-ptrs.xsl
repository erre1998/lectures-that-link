<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <xsl:output indent="yes"/>
  
  <xsl:template match="node() | @* | comment() | processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="event[@type='lecture']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="eventName"/>
      <xsl:copy-of select="ptr"/>
      <xsl:apply-templates select="note | listPerson | org"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>