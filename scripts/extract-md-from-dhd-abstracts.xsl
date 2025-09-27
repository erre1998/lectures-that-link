<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <!-- This file serves to extract metadata from the XML files of contributions
  to the DHd conferences in 2020 and earlier. 
  @author Ulrike Henny-Krahmer -->
  
  <xsl:output indent="true"/>
  
  <xsl:template match="/">
    <events>
      <xsl:for-each select="collection('/home/ulrike/Git/DHd-Abstracts-2016/XML-files/')//TEI">
      <event type="contribution">
        <eventName><xsl:value-of select="normalize-space(.//titleStmt/title)"/></eventName>
        <idno type="file-id"><xsl:value-of select="@xml:id"/></idno>
        <listPerson>
          <xsl:for-each select=".//author">
            <person>
              <name><xsl:value-of select="string-join((name/surname,name/forename),', ')"/></name>
              <xsl:copy-of select="affiliation"/>
            </person>
          </xsl:for-each>
        </listPerson>
      </event>
      </xsl:for-each>
    </events>
  </xsl:template>
  
</xsl:stylesheet>