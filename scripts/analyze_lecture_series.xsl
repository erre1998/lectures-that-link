<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" xmlns:local="local"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="3.0">
  
  <!-- author of this script: Ulrike Henny-Krahmer -->
  
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
  <xsl:variable name="persons" select="//particDesc//person"/>
  <xsl:variable name="persons-female" select="$persons[gender='female']"/>
  <xsl:variable name="persons-male" select="$persons[gender='male']"/>
  <xsl:variable name="persons-non-binary" select="$persons[gender='non-binary']"/>
  
  <xsl:function name="local:get-continents-for-countries" as="xs:string+">
    <xsl:param name="countries"/>
    <xsl:for-each select="$countries">
      <xsl:value-of select="$places[@xml:id=current()]/bloc[@type='continent']/substring-after(@ref,'#')"/>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="local:get-countries-for-cities" as="xs:string+">
    <xsl:param name="cities"/>
    <xsl:for-each select="$cities">
      <xsl:value-of select="$places[@xml:id=current()]/country/substring-after(@ref,'#')"/>
    </xsl:for-each>
  </xsl:function>
  
  <xsl:function name="local:get-affiliation-city" as="xs:string+">
    <xsl:param name="context"/>
    <xsl:message><xsl:value-of select="$context/@xml:id"/></xsl:message>
    <xsl:for-each select="$context//affiliation/tokenize(translate(@corresp,'#',''),'\s')">
      <xsl:variable name="institution" select="$institutions[@xml:id=current()]"/>
      <xsl:choose>
        <xsl:when test="$institution/@xml:id=('self-employment','i4dh','legacy-page')">unknown</xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$institution/place">
            <xsl:variable name="place-id" select="substring-after(@corresp,'#')"/>
            <xsl:value-of select="$place-id"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>
  
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
    <!--<xsl:call-template name="lectures-per-year-plot"/>-->
    <!--<xsl:call-template name="gender-per-year-plot"/>-->
    <!--<xsl:call-template name="ls-location-links-plot"/>-->
    <!--<xsl:call-template name="ls-disciplines"/>-->
    
    <xsl:result-document href="../analyses/llm-topic.csv" method="text">
      <xsl:for-each select="$lectures//term[@type='topics-llm']/tokenize(normalize-space(.),',\s')">
        <xsl:value-of select="."/><xsl:text>
</xsl:text>
      </xsl:for-each>  
    </xsl:result-document>
    
  </xsl:template>
  
  <xsl:template name="ls-disciplines">
    <xsl:for-each select="$lecture-series">
      <xsl:variable name="ls-id" select="@xml:id"/>
      <xsl:result-document href="../analyses/ls-disciplines-{$ls-id}.html">
        <html>
          <head>
            <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
          </head>
          <body>
            <table>
              <tr>
                <td><div id="myDiv1" style="width:700px;height:550px;"/></td>
              </tr>
            </table>
            <script>
              var trace1 = {
              y: [<xsl:for-each select="//taxonomy[@xml:id='disciplines']/category">
                <xsl:sort select="count($lectures[ancestor::event[@type='lecture-series'][@xml:id=$ls-id]][.//term[@type='discipline']/tokenize(translate(@corresp,'#',''),'\s')=current()/@xml:id])" data-type="number" order="descending"/>
                <xsl:value-of select="count($lectures[ancestor::event[@type='lecture-series'][@xml:id=$ls-id]][.//term[@type='discipline']/tokenize(translate(@corresp,'#',''),'\s')=current()/@xml:id])"/>
                <xsl:if test="position()!=last()">,</xsl:if>
              </xsl:for-each>],
              x: [<xsl:for-each select="//taxonomy[@xml:id='disciplines']/category">
                <xsl:sort select="count($lectures[ancestor::event[@type='lecture-series'][@xml:id=$ls-id]][.//term[@type='discipline']/tokenize(translate(@corresp,'#',''),'\s')=current()/@xml:id])" data-type="number" order="descending"/>
                '<xsl:value-of select="catDesc"/>'
                <xsl:if test="position()!=last()">,</xsl:if>
              </xsl:for-each>],
              type: 'bar',
              name: 'disciplines'
              };
              
              var data = [trace1];
              var layout = {
              yaxis: {title: {text: "number of lectures"}},
              xaxis: {tickangle: 45},
              margin: {b: 150}
              };
              
              Plotly.newPlot('myDiv1', data, layout);
              
            </script>
          </body>
        </html>
      </xsl:result-document>
    </xsl:for-each>
    
    
    <xsl:result-document href="../analyses/ls-disciplines-overview.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv1" style="width:700px;height:550px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            y: [<xsl:for-each select="//taxonomy[@xml:id='disciplines']/category">
              <xsl:sort select="count($lectures[.//term[@type='discipline']/tokenize(translate(@corresp,'#',''),'\s')=current()/@xml:id])" data-type="number" order="descending"/>
              <xsl:value-of select="count($lectures[.//term[@type='discipline']/tokenize(translate(@corresp,'#',''),'\s')=current()/@xml:id])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:for-each select="//taxonomy[@xml:id='disciplines']/category">
              <xsl:sort select="count($lectures[.//term[@type='discipline']/tokenize(translate(@corresp,'#',''),'\s')=current()/@xml:id])" data-type="number" order="descending"/>
              '<xsl:value-of select="catDesc"/>'
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'bar',
            name: 'disciplines'
            };
            
            var data = [trace1];
            var layout = {
            yaxis: {title: {text: "number of lectures"}},
            xaxis: {tickangle: 45},
            margin: {b: 150}
            };
            
            Plotly.newPlot('myDiv1', data, layout);
            
          </script>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template name="ls-location-links-plot">
    <xsl:result-document href="../analyses/ls-location-links-plot.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv1" style="width:600px;height:500px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            y: [<xsl:for-each select="$lecture-series">
              <xsl:variable name="ls-cities" select="tokenize(translate(@where,'#',''),'\s')"/>
              <xsl:variable name="terms" select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]"/>
              <xsl:value-of select="count($terms/event[@type='lecture'][local:get-affiliation-city(.)=$ls-cities]) div count($terms/event[@type='lecture'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'local'
            };
            
            var trace2 = {
            y: [<xsl:for-each select="$lecture-series">
              <xsl:variable name="ls-cities" select="tokenize(translate(@where,'#',''),'\s')"/>
              <xsl:variable name="ls-countries" select="local:get-countries-for-cities($ls-cities)"/>
              <xsl:variable name="terms" select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]"/>
              <xsl:value-of select="count($terms/event[@type='lecture'][local:get-affiliation-city(.)!=$ls-cities][local:get-countries-for-cities(local:get-affiliation-city(.))=$ls-countries]) div count($terms/event[@type='lecture'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'national'
            };
            
            var trace3 = {
            y: [<xsl:for-each select="$lecture-series">
              <xsl:variable name="ls-cities" select="tokenize(translate(@where,'#',''),'\s')"/>
              <xsl:variable name="ls-countries" select="local:get-countries-for-cities($ls-cities)"/>
              <xsl:variable name="ls-continents" select="local:get-continents-for-countries($ls-countries)"/>
              <xsl:variable name="terms" select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]"/>
              <xsl:value-of select="count($terms/event[@type='lecture'][local:get-affiliation-city(.)!=$ls-cities][local:get-countries-for-cities(local:get-affiliation-city(.))!=$ls-countries][local:get-continents-for-countries(local:get-countries-for-cities(local:get-affiliation-city(.)))='europe']) div count($terms/event[@type='lecture'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'European'
            };
            
            var trace4 = {
            y: [<xsl:for-each select="$lecture-series">
              <xsl:variable name="ls-cities" select="tokenize(translate(@where,'#',''),'\s')"/>
              <xsl:variable name="ls-countries" select="local:get-countries-for-cities($ls-cities)"/>
              <xsl:variable name="ls-continents" select="local:get-continents-for-countries($ls-countries)"/>
              <xsl:variable name="terms" select="event[@type='lecture-series-term'][2013 &lt; number(substring(@from,1,4))][number(substring(@from,1,4)) &lt; 2025]"/>
              <xsl:value-of select="count($terms/event[@type='lecture'][local:get-affiliation-city(.)!=$ls-cities][local:get-countries-for-cities(local:get-affiliation-city(.))!=$ls-countries][local:get-continents-for-countries(local:get-countries-for-cities(local:get-affiliation-city(.)))!='europe']) div count($terms/event[@type='lecture'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            type: 'box',
            name: 'other continents'
            };
            
            var data = [trace1,trace2,trace3,trace4];
            var layout = {
            yaxis: {range: [0,1], title: {text: "percentage of lectures per series"}}
            };
            
            Plotly.newPlot('myDiv1', data, layout);
            
          </script>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template name="gender-per-year-plot">
    <xsl:result-document href="../analyses/gender-per-year-plot.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv" style="width:620px;height:400px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            y: [<xsl:for-each select="$years">
              <xsl:value-of select="count($lectures[number(substring(@when,1,4))=current()][.//person[@role='speaker']/substring-after(@corresp,'#')=$persons-female/@xml:id])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:value-of select="string-join($years,',')"/>],
            type: 'bar',
            name: 'female'
            };
            
            var trace2 = {
            y: [<xsl:for-each select="$years">
              <xsl:value-of select="count($lectures[number(substring(@when,1,4))=current()][.//person[@role='speaker']/substring-after(@corresp,'#')=$persons-male/@xml:id])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:value-of select="string-join($years,',')"/>],
            type: 'bar',
            name: 'male'
            };
            
            var trace3 = {
            y: [<xsl:for-each select="$years">
              <xsl:value-of select="count($lectures[number(substring(@when,1,4))=current()][.//person[@role='speaker']/substring-after(@corresp,'#')=$persons-non-binary/@xml:id])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:value-of select="string-join($years,',')"/>],
            type: 'bar',
            name: 'non-binary'
            };
            
            
            var data = [trace1,trace2,trace3];
            var layout = {
            barmode: "stack",
            yaxis: {title: {text: "number of lectures"}}
            };
            
            Plotly.newPlot('myDiv', data, layout);
          </script>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template name="lectures-per-year-plot">
    <xsl:result-document href="../analyses/lectures-per-year-plot.html">
      <html>
        <head>
          <script src="https://cdn.plot.ly/plotly-3.0.1.min.js" charset="utf-8"/>
        </head>
        <body>
          <table>
            <tr>
              <td><div id="myDiv" style="width:600px;height:400px;"/></td>
            </tr>
          </table>
          <script>
            var trace1 = {
            y: [<xsl:for-each select="$years">
              <xsl:value-of select="count($lectures[number(substring(@when,1,4))=current()][.//term[@type='speech']='in person'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:value-of select="string-join($years,',')"/>],
            type: 'bar',
            name: 'in person'
            };
            
            var trace2 = {
            y: [<xsl:for-each select="$years">
              <xsl:value-of select="count($lectures[number(substring(@when,1,4))=current()][.//term[@type='speech']='online'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:value-of select="string-join($years,',')"/>],
            type: 'bar',
            name: 'online'
            };
            
            var trace3 = {
            y: [<xsl:for-each select="$years">
              <xsl:value-of select="count($lectures[number(substring(@when,1,4))=current()][.//term[@type='speech']='canceled'])"/>
              <xsl:if test="position()!=last()">,</xsl:if>
            </xsl:for-each>],
            x: [<xsl:value-of select="string-join($years,',')"/>],
            type: 'bar',
            name: 'canceled'
            };
            
            
            var data = [trace1,trace2,trace3];
            var layout = {
            barmode: "stack",
            yaxis: {title: {text: "number of lectures"}}
            };
            
            Plotly.newPlot('myDiv', data, layout);
          </script>
        </body>
      </html>
    </xsl:result-document>
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