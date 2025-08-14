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
  
  <xsl:template match="note[@type='keywords'][ancestor::event[@type='lecture'][@xml:id='ls41_t1_l13' or @xml:id='ls41_t1_l14' or @xml:id='ls41_t1_l15' or @xml:id='ls44_t1_l1' or @xml:id='ls44_t1_l2' or @xml:id='ls44_t1_l3' or @xml:id='ls44_t1_l4' or @xml:id='ls44_t1_l5' or @xml:id='ls44_t1_l6' or @xml:id='ls44_t2_l1' or @xml:id='ls44_t2_l2' or @xml:id='ls44_t2_l3' or @xml:id='ls44_t2_l4' or @xml:id='ls44_t2_l5' or @xml:id='ls44_t2_l6' or @xml:id='ls44_t2_l7' or @xml:id='ls44_t3_l1' or @xml:id='ls44_t3_l2' or @xml:id='ls44_t3_l3' or @xml:id='ls44_t3_l4' or @xml:id='ls44_t3_l5' or @xml:id='ls44_t3_l6' or @xml:id='ls44_t3_l7' or @xml:id='ls44_t3_l8' or @xml:id='ls45_t1_l1' or @xml:id='ls45_t1_l2' or @xml:id='ls45_t1_l3' or @xml:id='ls45_t1_l4' or @xml:id='ls45_t1_l5' or @xml:id='ls45_t1_l6' or @xml:id='ls45_t1_l7' or @xml:id='ls45_t1_l8' or @xml:id='ls45_t1_l9' or @xml:id='ls45_t1_l10' or @xml:id='ls45_t1_l11' or @xml:id='ls45_t1_l12' or @xml:id='ls45_t1_l13' or @xml:id='ls45_t1_l14' or @xml:id='ls45_t1_l15' or @xml:id='ls46_t1_l1' or @xml:id='ls46_t1_l2' or @xml:id='ls46_t1_l3' or @xml:id='ls46_t1_l4' or @xml:id='ls46_t1_l5' or @xml:id='ls46_t1_l6' or @xml:id='ls42_t1_l1' or @xml:id='ls42_t1_l2' or @xml:id='ls42_t1_l3' or @xml:id='ls42_t1_l4' or @xml:id='ls42_t1_l5' or @xml:id='ls42_t1_l6' or @xml:id='ls42_t1_l7' or @xml:id='ls42_t1_l8' or @xml:id='ls42_t1_l9' or @xml:id='ls42_t1_l10' or @xml:id='ls42_t1_l11' or @xml:id='ls42_t1_l12' or @xml:id='ls42_t1_l13' or @xml:id='ls42_t1_l14' or @xml:id='ls42_t1_l15' or @xml:id='ls43_t1_l1' or @xml:id='ls43_t1_l2' or @xml:id='ls43_t1_l3' or @xml:id='ls43_t1_l4' or @xml:id='ls43_t2_l1' or @xml:id='ls43_t2_l2' or @xml:id='ls43_t2_l3' or @xml:id='ls43_t2_l4' or @xml:id='ls43_t2_l5' or @xml:id='ls43_t2_l6' or @xml:id='ls43_t2_l7' or @xml:id='ls43_t2_l8' or @xml:id='ls43_t3_l1' or @xml:id='ls43_t3_l2' or @xml:id='ls43_t3_l3' or @xml:id='ls43_t3_l4' or @xml:id='ls43_t4_l1' or @xml:id='ls43_t4_l2' or @xml:id='ls43_t4_l3' or @xml:id='ls43_t4_l4' or @xml:id='ls43_t4_l5' or @xml:id='ls43_t4_l6' or @xml:id='ls43_t4_l7' or @xml:id='ls43_t5_l1' or @xml:id='ls43_t5_l2' or @xml:id='ls43_t5_l3' or @xml:id='ls43_t5_l4' or @xml:id='ls43_t5_l5' or @xml:id='ls43_t5_l6' or @xml:id='ls43_t5_l7' or @xml:id='ls43_t5_l8' or @xml:id='ls43_t5_l9' or @xml:id='ls43_t5_l10' or @xml:id='ls43_t5_l11' or @xml:id='ls43_t5_l12' or @xml:id='ls43_t5_l13' or @xml:id='ls43_t5_l14' or @xml:id='ls43_t6_l1' or @xml:id='ls43_t6_l2' or @xml:id='ls43_t6_l3' or @xml:id='ls43_t6_l4' or @xml:id='ls43_t7_l1' or @xml:id='ls43_t7_l2' or @xml:id='ls43_t7_l3' or @xml:id='ls43_t7_l4' or @xml:id='ls43_t7_l5' or @xml:id='ls43_t7_l6' or @xml:id='ls43_t7_l7' or @xml:id='ls43_t8_l1' or @xml:id='ls43_t8_l2' or @xml:id='ls43_t9_l1' or @xml:id='ls43_t9_l2' or @xml:id='ls43_t9_l3']]">
    <xsl:variable name="event-id" select="ancestor::event[@type='lecture']/@xml:id"/>
    <note type="keywords" xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="term[@type='discipline' or @type='topic']"/>
      <term type="topics-llm"><xsl:value-of select="$llm-keywords//local:response[@id=$event-id]"/></term>
    </note>
  </xsl:template>
  
</xsl:stylesheet>