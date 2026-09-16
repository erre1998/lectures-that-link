<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math tei local" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:local="local" xmlns="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <!-- This file serves to enrich the DHd conference data (as stored in dhd-conference-data.xml)
    by comparing it to a list of contributor names with
    additional identifiers (from ORCID and Wikidata) collected by Charlotte Grünig in a tabular format.
    
    input file: dhd-conference-data.xml
  
  @author: Ulrike Henny-Krahmer -->
  
  <xsl:variable name="dhd-contributors-file" select="doc('../analyses/contribution-eadh2026/dhd-conference-contributors-enriched.xml')"/>
  
  <!-- copy all, -->
  <xsl:template match="node()|@*|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*|comment()|processing-instruction()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- but ... -->
  <!-- look for identifiers for persons who have none so far -->
  <xsl:template match="tei:person[not(tei:idno)]">
    <!-- copy the person element itself and its existing child elements -->
    <xsl:copy>
      <xsl:copy-of select="child::*"/>
      <xsl:variable name="person-dhd-enriched" select="$dhd-contributors-file//local:row[local:elem[@name='name']/normalize-space(.)=current()/tei:name/normalize-space(.)]"/>
      <xsl:variable name="orcid" select="$person-dhd-enriched//local:elem[@name='orcid']"/>
      <xsl:variable name="wikidata" select="$person-dhd-enriched//local:elem[@name='wikidata']"/>
      <xsl:if test="$orcid">
        <idno type="orcid"><xsl:value-of select="$orcid"/></idno>
      </xsl:if>
      <xsl:if test="$wikidata">
        <idno type="wikidata"><xsl:value-of select="$wikidata"/></idno>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <!-- look for identifiers for persons who have an orcid so far, but no wikidata ID -->
  <xsl:template match="tei:person[tei:idno[@type='orcid']][not(tei:idno[@type='wikidata'])]">
    <!-- copy the person element itself and its existing child elements -->
    <xsl:copy>
      <xsl:copy-of select="child::*"/>
      <xsl:variable name="person-dhd-enriched" select="$dhd-contributors-file//local:row[local:elem[@name='name']/normalize-space(.)=current()/tei:name/normalize-space(.)]"/>
      <xsl:variable name="wikidata" select="$person-dhd-enriched//local:elem[@name='wikidata']"/>
      <xsl:if test="$wikidata">
        <idno type="wikidata"><xsl:value-of select="$wikidata"/></idno>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:stylesheet>