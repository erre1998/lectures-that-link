<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <!-- script to analyze speakers of DHd contributions and DH lecture series
  in conjunction
  
  @author: Ulrike Henny-Krahmer
  -->
  
  <xsl:variable name="lectures-file" select="document('../dh-lecture-series.xml')"/>
  <xsl:variable name="dhd-abstracts-file" select="document('../analyses/contribution-dhd2026/dhd-conference-data.xml')"/>
  
  <xsl:variable name="selection-ls" select="('ls22', 'ls23', 'ls42', 'ls10', 'ls11',
    'ls12', 'ls13', 'ls14', 'ls15', 'ls16', 'ls17', 'ls18', 'ls19', 'ls20', 'ls21', 'ls8', 'ls9',
    'ls35', 'ls36', 'ls37', 'ls38', 'ls39', 'ls40', 'ls41', 'ls43', 'ls45')"/>
  <xsl:variable name="selection-years" select="('2016','2017','2018','2019','2020','2022','2023','2025')"/>
  
  <xsl:variable name="relevant-lectures" select="$lectures-file//event[@type='lecture'][./ancestor::event[@type='lecture-series']/@xml:id = $selection-ls][substring(@when,1,4)=$selection-years]"/>
  
  <xsl:template match="/">
    <!-- number of lectures in the selected data set: -->
    <!--<xsl:value-of select="count($relevant-lectures)"/>-->
    
    <!--<xsl:value-of select="count(distinct-values($relevant-lectures//person[@role='speaker']/@corresp/tokenize(.,'\s')))"/>
  -->
  
    <!--<xsl:call-template name="lectures-per-speaker"/>-->
    <!--<xsl:call-template name="contributions-per-person"/>-->
    
    
  
  </xsl:template>
  
  <xsl:template name="contributions-per-person">
    <xsl:result-document href="../analyses/contribution-dhd2026/contributions-per-person.csv" method="text" encoding="UTF-8">
      <xsl:text>speaker-name,number-of-lectures</xsl:text>
      <xsl:text>
</xsl:text>
      <xsl:for-each-group select="$dhd-abstracts-file//person" group-by="name">
        <xsl:sort select="count(current-group())"/>
        <xsl:text>'</xsl:text><xsl:value-of select="current-grouping-key()"/><xsl:text>'</xsl:text>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="count(current-group())"/>
        <xsl:text>
</xsl:text>
      </xsl:for-each-group>
    </xsl:result-document>
    <xsl:result-document href="../analyses/contribution-dhd2026/contributions-per-person-plot.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv" style="width:400px;height:400px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            x: [<xsl:for-each-group select="$dhd-abstracts-file//person" group-by="name">
              <xsl:value-of select="count(current-group())"/>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each-group>],
            type: 'histogram'
            };
            
            
            var data = [trace1];
            var layout = {
            barmode: "stack",
            yaxis: {title: {text: "number of persons"}},
            xaxis: {title: {text: "number of contributions"}}
            };
            
            Plotly.newPlot('myDiv', data, layout);
          </script>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template name="lectures-per-speaker">
    <xsl:result-document href="../analyses/contribution-dhd2026/lectures-per-speaker.csv" method="text" encoding="UTF-8">
      <xsl:text>speaker-name,number-of-lectures</xsl:text>
      <xsl:text>
</xsl:text>
      <xsl:for-each-group select="$relevant-lectures//person[@role='speaker']" group-by="@corresp">
        <xsl:sort select="count(current-group())"/>
        <xsl:variable name="speaker-id" select="substring-after(current-grouping-key(),'#')"/>
        <xsl:variable name="speaker" select="//teiHeader//person[@xml:id=$speaker-id]"/>
        <xsl:value-of select="string-join(($speaker//forename, $speaker//surname),' ')"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="count(current-group())"/>
        <xsl:text>
</xsl:text>
      </xsl:for-each-group>
    </xsl:result-document>
    <xsl:result-document href="../analyses/contribution-dhd2026/lectures-per-speaker-plot.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv" style="width:400px;height:400px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            x: [<xsl:for-each-group select="$relevant-lectures//person[@role='speaker']" group-by="@corresp">
              <xsl:value-of select="count(current-group())"/>
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each-group>],
            type: 'histogram'
            };
            
            
            var data = [trace1];
            var layout = {
            barmode: "stack",
            yaxis: {title: {text: "number of speakers"}},
            xaxis: {title: {text: "number of lectures"}}
            };
            
            Plotly.newPlot('myDiv', data, layout);
          </script>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>
  
</xsl:stylesheet>