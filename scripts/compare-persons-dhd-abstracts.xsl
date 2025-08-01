<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:local="local"
  version="3.0">
  
  <!-- This file serves to compare the authors of DHd conference abstracts
  with the speakers in DH lecture series.
  
  @author: Ulrike Henny-Krahmer -->
  
  <xsl:output indent="yes"/>
  
  <xsl:variable name="lectures-file" select="document('../dh-lecture-series.xml')"/>
  <xsl:variable name="dhd-abstracts-file" select="document('../analyses/contribution-dhd2026/dhd-conference-data.xml')"/>
  
  <xsl:variable name="selection-ls" select="('ls22', 'ls23', 'ls42', 'ls10', 'ls11',
    'ls12', 'ls13', 'ls14', 'ls15', 'ls16', 'ls17', 'ls18', 'ls19', 'ls20', 'ls21', 'ls8', 'ls9',
    'ls35', 'ls36', 'ls37', 'ls38', 'ls39', 'ls40', 'ls41', 'ls43', 'ls45')"/>
  <xsl:variable name="selection-years" select="('2016','2017','2018','2019','2020','2022','2023','2025')"/>
  
  <xsl:variable name="relevant-lectures" select="$lectures-file//event[@type='lecture'][./ancestor::event[@type='lecture-series']/@xml:id = $selection-ls][substring(@when,1,4)=$selection-years]"/>
  <xsl:variable name="intersections-contributors-dhd" select="document('../analyses/contribution-dhd2026/intersections-contributors-dhd.xml')"/>
  <xsl:variable name="speakers-both" select="$intersections-contributors-dhd//person[note[@type='lecture-series']='yes']"/>
  <xsl:variable name="intersections-speakers-lecture-series" select="document('../analyses/contribution-dhd2026/intersections-speakers-lecture-series.xml')"/>
  
  <xsl:template match="/">
    <!--<xsl:call-template name="intersections-contributors-dhd"/>-->
    <!--<xsl:call-template name="intersections-speakers-lecture-series"/>-->
    <xsl:call-template name="intersections-both"/>
  </xsl:template>
  
  <xsl:function name="local:get-speaker-id" as="xs:string">
    <xsl:param name="speaker-name"/>
    <xsl:message><xsl:value-of select="$speaker-name"/></xsl:message>
    <!--  
    <xsl:variable name="speaker-surname" select="tokenize($speaker-name,',\s')[1]"/>
    <xsl:variable name="speaker-forename" select="tokenize($speaker-name,',\s')[2]"/>
    <xsl:variable name="speaker-person" select="$lectures-file//particDesc//person[name/surname=$speaker-surname and name/forename=$speaker-forename]"/>
    <xsl:variable name="speaker-id" select="$speaker-person/@xml:id"/>
    -->
    <xsl:variable name="speaker-id" select="$intersections-contributors-dhd//person[name=$speaker-name]/idno[@type='lecture-series']"/>
    <xsl:message><xsl:value-of select="$speaker-id"/></xsl:message>
    <xsl:value-of select="$speaker-id"/>
  </xsl:function>
  
  <xsl:template name="intersections-both">
    
    <xsl:result-document href="../analyses/contribution-dhd2026/intersection-score.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv1" style="width:500px;height:500px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            y: [<xsl:for-each select="$speakers-both">
              <xsl:variable name="speaker-name" select="name"/>
              <xsl:variable name="speaker-id" select="local:get-speaker-id($speaker-name)"/>
              <xsl:message><xsl:value-of select="$speaker-name"/></xsl:message>
              <xsl:variable name="num-contributions-dhd" select="count($dhd-abstracts-file//event[.//person/name=$speaker-name])"/>
              <xsl:variable name="quote-dhd" select="$num-contributions-dhd div count($dhd-abstracts-file//event)"/>
              <xsl:message>No. contributions DHd: <xsl:value-of select="$num-contributions-dhd"/></xsl:message>
              <xsl:variable name="num-lectures" select="count($relevant-lectures[.//person[@role='speaker']/@corresp = concat('#',local:get-speaker-id($speaker-name))])"/>
              <xsl:message>No. lectures: <xsl:value-of select="$num-lectures"/></xsl:message>
              <xsl:variable name="quote-lectures" select="$num-lectures div count($relevant-lectures)"/>
              <xsl:variable name="intersection-score" select="$quote-dhd div $quote-lectures"/>
              <xsl:value-of select="$intersection-score"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'contributors/speakers'
            };
            
            
            var data = [trace1];
            var layout = {
            yaxis: {title: {text: "intersection score"}}
            };
            
            Plotly.newPlot('myDiv1', data, layout);
            
          </script>
        </body>
      </html>
    </xsl:result-document>
    
    
     
  </xsl:template>
  
  <xsl:template name="intersections-speakers-lecture-series">
    <listPerson>
      <xsl:for-each-group select="$relevant-lectures//person[@role='speaker']" group-by="@corresp">
        <xsl:variable name="speaker-id" select="substring-after(current-grouping-key(),'#')"/>
        <xsl:variable name="speaker" select="//teiHeader//person[@xml:id=$speaker-id]"/>
        <xsl:variable name="speaker-name" select="string-join(($speaker//surname, $speaker//forename),', ')"/>
        <person>
          <name><xsl:value-of select="$speaker-name"/></name>
          <note type="lecture-series">yes</note>
          <note type="dhd-abstracts">
            <xsl:choose>
              <xsl:when test="$intersections-contributors-dhd//person[normalize-space(name)=normalize-space($speaker-name)]">yes</xsl:when>
              <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
          </note>
        </person>
      </xsl:for-each-group>
    </listPerson>
  </xsl:template>
  
  <xsl:template name="intersections-contributors-dhd">
    <listPerson>
      <xsl:for-each-group select="$dhd-abstracts-file//person" group-by="name">
        <xsl:sort select="current-grouping-key()"/>
        <xsl:variable name="surname" select="tokenize(current-grouping-key(),',\s')[1]"/>
        <xsl:variable name="forename" select="tokenize(current-grouping-key(),',\s')[2]"/>
        <person>
          <name><xsl:value-of select="current-grouping-key()"/></name>
          <xsl:if test="current-group()[idno[@type='orcid']]">
            <xsl:copy-of select="current-group()[idno[@type='orcid']][1]/idno[@type='orcid']"/>
          </xsl:if>
          <note type="dhd-abstracts">yes</note>
          <xsl:variable name="idno-ls">
            <xsl:choose>
              <xsl:when test="current-group()[idno[@type='orcid']]">
                <xsl:variable name="orcid" select="current-group()[idno[@type='orcid']][1]/idno[@type='orcid']"/>
                <xsl:choose>
                  <xsl:when test="$lectures-file//particDesc//person[contains(idno[@type='orcid'],$orcid)]">
                    <xsl:value-of select="$lectures-file//particDesc//person[contains(idno[@type='orcid'],$orcid)]/@xml:id"/>
                  </xsl:when>
                  <xsl:when test="$lectures-file//particDesc//person[name/surname=$surname and name/forename=$forename]">
                    <xsl:value-of select="$lectures-file//particDesc//person[name/surname=$surname and name/forename=$forename]/@xml:id"/>
                  </xsl:when>
                  <xsl:otherwise><xsl:text>not found</xsl:text></xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="$lectures-file//particDesc//person[name/surname=$surname and name/forename=$forename]">
                <xsl:value-of select="$lectures-file//particDesc//person[name/surname=$surname and name/forename=$forename]/@xml:id"/>
              </xsl:when>
              <xsl:otherwise><xsl:text>not found</xsl:text></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <note type="lecture-series">
            <xsl:choose>
              <xsl:when test="$relevant-lectures[.//person[@role='speaker']/@corresp = concat('#',$idno-ls)]">yes</xsl:when>
              <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
          </note>
          <idno type="lecture-series">
            <xsl:value-of select="$idno-ls"/>
          </idno>
        </person>
      </xsl:for-each-group>
    </listPerson>
  </xsl:template>
</xsl:stylesheet>