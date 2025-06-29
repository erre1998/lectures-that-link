<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math local" 
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://gexf.net/1.3" xmlns:local="local"
  version="3.0">
  
  <!-- author: Ulrike Henny-Krahmer -->
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:variable name="ls-data" select="//event[@type='lecture-series'][@xml:id='ls10']"/>
  <xsl:variable name="ls-places">
    <!-- list of place for the institutions that speakers are affiliated with; 
    a place can occur several times in this list -->
    <local:places>
      <xsl:for-each select="$ls-data//event[@type='lecture']//affiliation/tokenize(translate(@corresp,'#',''),'\s')">
        <xsl:variable name="places" select="$ls-institution-list[@xml:id=current()]/place/substring-after(@corresp,'#')"/>
        <xsl:for-each select="$places">
          <local:place><xsl:value-of select="."/></local:place>
        </xsl:for-each>
      </xsl:for-each>
    </local:places>
  </xsl:variable>
  <xsl:variable name="ls-place-list" select="//settingDesc/listPlace/place"/>
  <xsl:variable name="ls-institution-list" select="//particDesc/listOrg/org"/>
  
  <xsl:function name="local:get-geographical-context" as="xs:string">
    <xsl:param name="context"/>
    <xsl:variable name="country" select="$ls-place-list[@xml:id=$context]/country/substring-after(@ref,'#')"/>
    <xsl:choose>
      <xsl:when test="$country='germany'">Germany</xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$ls-place-list[@xml:id=$country]/bloc[@type='continent'][@ref='#europe']">Europe</xsl:when>
          <xsl:otherwise>beyond Europe</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="/">
    
    <gexf xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://gexf.net/1.3 https://gexf.net/1.3/gexf.xsd"
      xmlns="http://gexf.net/1.3" version="1.3">
      <meta lastmodifieddate="2025-06-09">
        <creator>Ulrike Henny-Krahmer</creator>
        <creator>Fernanda Alvares Freire</creator>
        <creator>Erik Renz</creator>
        <description>Network of lecture series "DH in Focus"</description>
      </meta>
      <graph mode="static" defaultedgetype="undirected">
        <attributes class="node">
          <attribute id="0" title="place-name" type="string"/>
          <attribute id="1" title="number-of-affiliations" type="integer"/>
          <attribute id="2" title="geographical-context" type="string"/>
        </attributes>
        <attributes class="edge">
          <attribute id="0" title="number-of-lectures" type="integer"/>
        </attributes>
        <nodes>
          <node id="0" label="rostock">
            <attvalues>
              <attvalue for="0" value="Rostock"/>
              <attvalue for="1" value="{count($ls-places//local:place[.='rostock'])}"/>
              <attvalue for="2" value="local"/>
            </attvalues>
          </node>
          <xsl:for-each-group select="$ls-places//local:place[.!='rostock']" group-by=".">
            <xsl:sort select="current-grouping-key()"/>
            <node id="{position()+1}" label="{current-grouping-key()}">
              <attvalues>
                <attvalue for="0" value="{$ls-place-list[@xml:id=current-grouping-key()]/name}"/>
                <attvalue for="1" value="{count(current-group())}"/>
                <attvalue for="2" value="{local:get-geographical-context(current-grouping-key())}"/>
              </attvalues>
            </node>
          </xsl:for-each-group>
        </nodes>
        <edges>
          <edge source="0" target="0">
            <attvalues>
              <attvalue for="0" value="{count($ls-places//local:place[.='rostock'])}"/>
            </attvalues>
          </edge>
          <xsl:for-each-group select="$ls-places//local:place[.!='rostock']" group-by=".">
            <xsl:sort select="current-grouping-key()"/>
            <edge source="0" target="{position()+1}">
              <attvalues>
                <attvalue for="0" value="{count(current-group())}"/>
              </attvalues>
            </edge>
          </xsl:for-each-group>
        </edges>
      </graph>
    </gexf>
  </xsl:template>
  
</xsl:stylesheet>