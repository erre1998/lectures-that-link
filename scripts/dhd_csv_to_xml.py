#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
This file serves to convert metadata about the contributions to DHd conferences into an XML-TEI format.
The source of the data is the following GitHub organization: https://github.com/DHd-Verband

@author: Ulrike Henny-Krahmer
'''


import pandas as pd
from os.path import join
from lxml import etree
import ast
from xml.sax.saxutils import unescape

input_dir = "/home/ulrike/Git/lectures-that-link/analyses/contribution-dhd2026"
input_file = "package_DHd2020.csv"
input_csv = pd.read_csv(join(input_dir, input_file), sep=",", header=0)


root = etree.Element("events")

for index, row in input_csv.iterrows():
	
	event = etree.SubElement(root, "event", type="contribution")
	title = etree.SubElement(event, "eventName")
	title.text = row["title"]
	abstract_doi = etree.SubElement(event, "idno", type="abstract-doi")
	abstract_doi.text = row["conceptdoi"]
	persList = etree.SubElement(event, "listPerson")
	persons = ast.literal_eval(row["creators"])
	
	for person in persons:
		
		personXML = etree.SubElement(persList, "person")
		persNameXML = etree.SubElement(personXML, "name")
		persNameXML.text = unescape(person["name"])
		affiliationXML = etree.SubElement(personXML, "affiliation")
		affiliationXML.text = unescape(person["affiliation"])
		if "orcid" in person:
			orcidXML = etree.SubElement(personXML, "idno", type="orcid")
			orcidXML.text = person["orcid"]
		
	
	
et = etree.ElementTree(root)
et.write('output.xml', pretty_print=True, encoding="unicode")

print("done")
