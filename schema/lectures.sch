<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  
  <sch:title>Schema controlling the TEI file dh-lecture-series.xml</sch:title>
  
  <sch:p>Author: Ulrike Henny-Krahmer</sch:p>
  
  <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
  
  <sch:pattern>
    <sch:rule context="tei:event[@type='lecture']">
      <sch:let name="event-id" value="@xml:id"/>
      <sch:assert test=".//tei:person[@role = 'speaker'][substring-after(@corresp,'#') = //tei:particDesc//tei:listPerson/tei:person/@xml:id]"><sch:value-of select="$event-id"/>: Error: the speaker ID was not found in the list of persons.</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>