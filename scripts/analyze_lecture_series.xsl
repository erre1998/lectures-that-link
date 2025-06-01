<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <xsl:variable name="lecture-series-data-completed" 
    select="('ls1','ls3','ls4','ls5','ls6','ls8','ls9','ls10',
    'ls11','ls12','ls13','ls14','ls15','ls16','ls17','ls18','ls19',
    'ls20','ls21','ls22','ls23','ls24','ls25','ls27','ls29',
    'ls30','ls31','ls33','ls34')"/>
  
  <!-- collect the completed data within our temporal scope: -->
  <xsl:variable name="lecture-series" select="//event[@type='lecture-series'][@xml:id=$lecture-series-data-completed]"/>
  <xsl:variable name="lecture-terms" select="$lecture-series/event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]"/>
  <xsl:variable name="lectures" select="$lecture-terms/event[@type='lecture']"/>
  <xsl:variable name="places" select="//settingDesc//place"/>
  <xsl:variable name="institutions" select="//particDesc//org"/>
  <xsl:variable name="years" select="2014 to 2025"/>
  
  <xsl:template match="/">
    <!--<xsl:call-template name="ls-structures-general"/>-->
    <!--<xsl:call-template name="number-of-lectures"/>-->
    <!--<xsl:call-template name="number-of-organizers"/>-->
    <!--<xsl:call-template name="number-of-speakers"/>-->
    <!--<xsl:call-template name="number-of-host-institutions"/>-->
    <!--<xsl:call-template name="number-of-affiliation-institutions"/>-->
    <!--<xsl:call-template name="number-of-host-cities"/>-->
    <!--<xsl:call-template name="number-of-host-countries"/>-->
    <!--<xsl:call-template name="number-of-affiliation-cities"/>-->
    <!--<xsl:call-template name="number-of-affiliation-countries"/>-->
    
    <xsl:value-of select="count($years)"/>
    
    
  </xsl:template>
  
  <xsl:template name="number-of-affiliation-countries">
    <xsl:variable name="countries" as="xs:string+">
      <xsl:for-each select="distinct-values($lectures//affiliation/tokenize(@corresp,'\s'))">
        <xsl:variable name="institution-name" select="substring-after(.,'#')"/>
        <xsl:variable name="city-names" select="$institutions[@xml:id=$institution-name]/place/substring-after(@corresp,'#')"/>
        <xsl:for-each select="$city-names">
          <xsl:value-of select="$places[@type='city'][@xml:id=current()]/country/@ref"/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:value-of select="count(distinct-values($countries))"/>
  </xsl:template>
  
  <xsl:template name="number-of-affiliation-cities">
    <xsl:variable name="cities" as="xs:string+">
      <xsl:for-each select="distinct-values($lectures//affiliation/tokenize(@corresp,'\s'))">
        <xsl:variable name="institution-name" select="substring-after(.,'#')"/>
        <xsl:variable name="city-names" select="$institutions[@xml:id=$institution-name]/place/@corresp"/>
        <xsl:for-each select="$city-names">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:value-of select="count(distinct-values($cities))"/>
  </xsl:template>
  
  <xsl:template name="number-of-host-countries">
    <xsl:variable name="countries" as="xs:string+">
      <xsl:for-each select="distinct-values($lecture-series/tokenize(@where,'\s'))">
        <xsl:variable name="city-name" select="substring-after(.,'#')"/>
        <xsl:variable name="country-name" select="$places[@type='city'][@xml:id=$city-name]/country/@ref"/>
        <xsl:value-of select="$country-name"/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:value-of select="count(distinct-values($countries))"/>
  </xsl:template>
  
  <xsl:template name="number-of-host-cities">
    <xsl:value-of select="count(distinct-values($lecture-series/tokenize(@where,'\s')))"/>
  </xsl:template>
  
  <xsl:template name="number-of-affiliation-institutions">
    <xsl:value-of select="count(distinct-values($lectures//affiliation/tokenize(@corresp,'\s')))"/>
  </xsl:template>
  
  <xsl:template name="number-of-host-institutions">
    <xsl:value-of select="count(distinct-values($lectures/org[@role='host-institution']/tokenize(@corresp,'\s')))"/>
  </xsl:template>
  
  <xsl:template name="number-of-speakers">
    <xsl:value-of select="count(distinct-values($lectures//person[@role='speaker']/@corresp))"/>
  </xsl:template>
  
  <xsl:template name="number-of-organizers">
    <xsl:value-of select="count(distinct-values($lecture-terms//org[@role='organizer']/tokenize(@corresp,'\s')))"/>
  </xsl:template>
  
  <xsl:template name="number-of-lectures">
    <xsl:value-of select="count($lecture-series/event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]/event[@type='lecture'])"/>
  </xsl:template>
  
  <xsl:template name="ls-structures-general">
    <xsl:result-document href="../analyses/ls-structure-plot.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv1" style="width:300px;height:500px;"/></td>
              <td><div id="myDiv2" style="width:300px;height:500px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            y: [<xsl:for-each select="$lecture-series">
              <xsl:value-of select="count(event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'lecture series'
            };
            
            var data = [trace1];
            var layout = {
            yaxis: {range: [0,16], title: {text: "number of terms per series"}}
            };
            
            Plotly.newPlot('myDiv1', data, layout);
            
            var trace2 = {
            y: [<xsl:for-each select="$lecture-series">
              <xsl:for-each select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]">
                <xsl:value-of select="count(event[@type='lecture'])"/>
                <xsl:if test="position()!=last()">,</xsl:if>
              </xsl:for-each>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'lecture series terms'
            };
            
            var data = [trace2];
            var layout = {
            yaxis: {range: [0,16], title: {text: "number of lectures per term"}}
            };
            
            Plotly.newPlot('myDiv2', data, layout);
          </script>
        </body>
      </html>
    </xsl:result-document>
    
    
    <xsl:result-document href="../analyses/ls-structure_terms-per-series.csv" method="text">
      <xsl:text>series-id,number-of-terms</xsl:text><xsl:text>
</xsl:text>
      <xsl:for-each select="//event[@type='lecture-series'][@xml:id=$lecture-series-data-completed]">
        <xsl:value-of select="@xml:id"/><xsl:text>,</xsl:text>
        <xsl:value-of select="count(event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025])"/>
        <xsl:if test="position()!=last()"><xsl:text>
</xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:result-document>
    
    
    <xsl:result-document href="../analyses/ls-structure_lectures-per-term.csv" method="text">
      <xsl:text>series-id,term-id,number-of-lectures</xsl:text><xsl:text>
</xsl:text>
      <xsl:for-each select="//event[@type='lecture-series'][@xml:id=$lecture-series-data-completed]">
        <xsl:for-each select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]">
          <xsl:value-of select="parent::event[@type='lecture-series']/@xml:id"/><xsl:text>,</xsl:text>
          <xsl:value-of select="@xml:id"/><xsl:text>,</xsl:text>
          <xsl:value-of select="count(event[@type='lecture'])"/>
          <xsl:if test="position()!=last()"><xsl:text>
</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:if test="position()!=last()"><xsl:text>
</xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:result-document>
  </xsl:template>
  
</xsl:stylesheet>