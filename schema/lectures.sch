<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  
  <sch:title>Schema controlling the TEI file dh-lecture-series.xml</sch:title>
  
  <sch:p>Author: Ulrike Henny-Krahmer</sch:p>
  
  <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
  
  <sch:pattern>
    <!-- check details of individual lecture events: -->
    <sch:rule context="tei:event[@type='lecture']">
      <sch:let name="event-id" value="@xml:id"/>
      <!-- check speaker ids: -->
      <sch:assert test=".//tei:person[@role = 'speaker'][substring-after(@corresp,'#') = //tei:particDesc//tei:listPerson/tei:person/@xml:id]"><sch:value-of select="$event-id"/>: Error: the speaker ID was not found in the list of persons.</sch:assert>
      <!-- check affiliation ids: -->
      <sch:assert test=".//tei:affiliation[tokenize(translate(@corresp,'#',''),'\s') = //tei:particDesc//tei:listOrg/tei:org/@xml:id]"><sch:value-of select="$event-id"/>: Error: the affiliation ID was not found in the list of organizations.</sch:assert>
      <!-- check host institution ids: -->
      <sch:assert test=".//tei:org[@role='host-institution'][tokenize(translate(@corresp,'#',''),'\s') = //tei:particDesc//tei:listOrg/tei:org/@xml:id]"><sch:value-of select="$event-id"/>: Error: the host institution ID was not found in the list of organizations.</sch:assert>
    </sch:rule>
    
    <!-- check details of lecture series terms: -->
    <sch:rule context="tei:event[@type='lecture-series-term']">
      <sch:let name="event-id" value="@xml:id"/>
      <!-- check organizer ids: -->
      <sch:assert test=".//tei:org[@role='organizer'][tokenize(translate(@corresp,'#',''),'\s') = //tei:particDesc//tei:listPerson/tei:person/@xml:id]"><sch:value-of select="$event-id"/>: Error: the organizer ID was not found in the list of persons.</sch:assert>
    </sch:rule>
    
    <!-- check details of the whole lecture series: -->
    <sch:rule context="tei:event[@type='lecture-series']">
      <sch:let name="event-id" value="@xml:id"/>
      <!-- check place ids: -->
      <sch:assert test=".[tokenize(translate(@where,'#',''),'\s') = //tei:settingDesc//tei:listPlace/tei:place/@xml:id]"><sch:value-of select="$event-id"/>: Error: the lecture series location ID was not found in the list of places.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>