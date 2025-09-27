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
  
  <xsl:template match="note[@type='keywords']">
    <xsl:variable name="lecture-id" select="ancestor::event[@type='lecture']/@xml:id"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="term[@type='discipline']"/>
      <xsl:copy-of select="doc('/home/ulrike/Dokumente/Publikationen/2025_DH-lecture-series/data/dh-lecture-series.xml')//event[@type='lecture'][@xml:id=$lecture-id]//term[@type='topic']"/>
      <xsl:copy-of select="term[@type='topics-llm']"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>