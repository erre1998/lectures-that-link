<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:for-each select="//event[@type='lecture-series']">
      <xsl:value-of select="@xml:id"/><xsl:text>,"</xsl:text>
      <xsl:value-of select="normalize-space(eventName[1])"/><xsl:text>"
</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>