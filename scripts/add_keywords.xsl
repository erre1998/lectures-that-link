<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math local" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:local="local"
  version="3.0">
  
  <!-- this script adds the keyword-responses of the llm to the main TEI file
  of the lectures -->
  
  <!--<xsl:output indent="yes"/>-->
  
  <xsl:variable name="llm-keywords" select="document('../analyses/llm-keyword-responses.xml')"/>
  
  <xsl:template match="node() | @* | comment() | processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="note[@type='keywords'][ancestor::event[@type='lecture-series'][@xml:id='ls33']]">
    <xsl:variable name="event-id" select="ancestor::event[@type='lecture']/@xml:id"/>
    <note type="keywords" xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="term[@type='discipline' or @type='topic']"/>
      <term type="topics-llm"><xsl:value-of select="$llm-keywords//local:response[@id=$event-id]"/></term>
    </note>
  </xsl:template>
  
</xsl:stylesheet>