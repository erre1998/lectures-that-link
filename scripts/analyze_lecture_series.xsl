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
  
  <xsl:template match="/">
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
          y: [<xsl:for-each select="//event[@type='lecture-series'][@xml:id=$lecture-series-data-completed]">
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
          y: [<xsl:for-each select="//event[@type='lecture-series'][@xml:id=$lecture-series-data-completed]">
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
        <xsl:value-of select="@xml:id"/><xsl:text>,</xsl:text>
        <xsl:for-each select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]">
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