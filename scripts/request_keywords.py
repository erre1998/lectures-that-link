#!/usr/bin/env python

""" fetches keywords for talks produced by a LLM based on the talks' titles and abstracts """

__author__ = "Ulrike Henny-Krahmer"
__license__ = "GPL"

import os
from mistralai import Mistral
from lxml import etree
import re
import time

input_file = "/home/ulrike/Git/lectures-that-link/dh-lecture-series.xml"
output_file = "/home/ulrike/Git/lectures-that-link/analyses/llm-keyword-responses.xml"

api_key = "7bFAj15ML05fv96SEt9iSuhOg7K2mtXp"
model = "mistral-large-latest"

client = Mistral(api_key=api_key)

tree = etree.parse(input_file)
lectures = tree.xpath("//tei:event[@type='lecture']", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})

message_intro = "Hello, I hope that you are well! I need your help with the following task: I have a list of talks from Digital Humanities lecture series and I need keywords that describe what each talk is about. I can give you the title and an abstract of each talk. In some cases, there is only a title and the abstract is 'not found'. In such cases, please give me the keywords based on the title alone. Please return a list of five keywords for every talk that I give to you. Please do not use the keyword 'digital humanities', as all the talks are from that field. The talks are in different languages. However, please return English keywords, not keywords in the original language of the talk if it is not English. Please use American English. Please return only the keywords in one line (no additional comments), separated by comma and with a whitespace after each comma (not before the comma). Please return the words in lower-case. Here is the first talk:"

root = etree.Element("responses")
n = 0

for lecture in lectures[800:895]:
	title = lecture.xpath("tei:eventName[1]/text()", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})
	title = re.sub(r"\s+", " ", title[0])
	abstract = lecture.xpath("tei:note[@type='abstract']//text()", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})
	abstract = " ".join(abstract)
	abstract = re.sub(r"\s+", " ", abstract)
	xml_id = lecture.xpath("@xml:id", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})
	
	#title = "Modellazione di oggetti digitali nel contesto del Web Semantico"
	#abstract = "Quando si ha a che fare con oggetti digitali – siano essi immagini, testi o audio – è necessario sempre corredarli di una descrizione, che ne specifichi i dettagli. Ad esempio, se si ha la scansione di un manoscritto, è necessario fornire informazioni aggiuntive quali il nome dell’autore e il luogo in cui il manoscritto è stato scritto. Al fine di rappresentare correttamente le informazioni a corredo degli oggetti digitali, si dovrebbero utilizzare ontologie specifiche e standardizzate. Questo seminario ha lo scopo di offrire una panoramica su come modellare gli oggetti digitali attraverso le ontologie sviluppate nel contesto del Web Semantico. In particolare, il seminario si concentrerà sull’ontologia sviluppata dalla nota community di Europeana, la Europeana Data Model (EDM) e cercherà di dare agli studenti gli strumenti per costruire semplici modellazioni di oggetti digitali."
	#xml_id  = "ls2_t8_l3"
	message_title = "Title: " + title
	message_abstract = "Abstract: " + abstract

	chat_response = client.chat.complete(
		model = model,
		messages = [
			{
				"role": "user",
				"content": message_intro + " " + message_title + "; " + message_abstract,
			},
		]
	)
	child = etree.SubElement(root, "response")
	child.text = chat_response.choices[0].message.content
	child.attrib["id"] = xml_id[0]
	n += 1
	print(n)
	
	time.sleep(10)

et = etree.ElementTree(root)
et.write(output_file, pretty_print=True, encoding="utf-8")

print("Done!")
