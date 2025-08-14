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

api_key = os.environ["MISTRAL_API_KEY"]
model = "mistral-large-latest"

client = Mistral(api_key=api_key)

tree = etree.parse(input_file)
lectures = tree.xpath("//tei:event[@type='lecture'][ancestor::tei:event[@type='lecture-series']][@xml:id='ls41_t1_l13' or @xml:id='ls41_t1_l14' or @xml:id='ls41_t1_l15' or @xml:id='ls44_t1_l1' or @xml:id='ls44_t1_l2' or @xml:id='ls44_t1_l3' or @xml:id='ls44_t1_l4' or @xml:id='ls44_t1_l5' or @xml:id='ls44_t1_l6' or @xml:id='ls44_t2_l1' or @xml:id='ls44_t2_l2' or @xml:id='ls44_t2_l3' or @xml:id='ls44_t2_l4' or @xml:id='ls44_t2_l5' or @xml:id='ls44_t2_l6' or @xml:id='ls44_t2_l7' or @xml:id='ls44_t3_l1' or @xml:id='ls44_t3_l2' or @xml:id='ls44_t3_l3' or @xml:id='ls44_t3_l4' or @xml:id='ls44_t3_l5' or @xml:id='ls44_t3_l6' or @xml:id='ls44_t3_l7' or @xml:id='ls44_t3_l8' or @xml:id='ls45_t1_l1' or @xml:id='ls45_t1_l2' or @xml:id='ls45_t1_l3' or @xml:id='ls45_t1_l4' or @xml:id='ls45_t1_l5' or @xml:id='ls45_t1_l6' or @xml:id='ls45_t1_l7' or @xml:id='ls45_t1_l8' or @xml:id='ls45_t1_l9' or @xml:id='ls45_t1_l10' or @xml:id='ls45_t1_l11' or @xml:id='ls45_t1_l12' or @xml:id='ls45_t1_l13' or @xml:id='ls45_t1_l14' or @xml:id='ls45_t1_l15' or @xml:id='ls46_t1_l1' or @xml:id='ls46_t1_l2' or @xml:id='ls46_t1_l3' or @xml:id='ls46_t1_l4' or @xml:id='ls46_t1_l5' or @xml:id='ls46_t1_l6' or @xml:id='ls42_t1_l1' or @xml:id='ls42_t1_l2' or @xml:id='ls42_t1_l3' or @xml:id='ls42_t1_l4' or @xml:id='ls42_t1_l5' or @xml:id='ls42_t1_l6' or @xml:id='ls42_t1_l7' or @xml:id='ls42_t1_l8' or @xml:id='ls42_t1_l9' or @xml:id='ls42_t1_l10' or @xml:id='ls42_t1_l11' or @xml:id='ls42_t1_l12' or @xml:id='ls42_t1_l13' or @xml:id='ls42_t1_l14' or @xml:id='ls42_t1_l15' or @xml:id='ls43_t1_l1' or @xml:id='ls43_t1_l2' or @xml:id='ls43_t1_l3' or @xml:id='ls43_t1_l4' or @xml:id='ls43_t2_l1' or @xml:id='ls43_t2_l2' or @xml:id='ls43_t2_l3' or @xml:id='ls43_t2_l4' or @xml:id='ls43_t2_l5' or @xml:id='ls43_t2_l6' or @xml:id='ls43_t2_l7' or @xml:id='ls43_t2_l8' or @xml:id='ls43_t3_l1' or @xml:id='ls43_t3_l2' or @xml:id='ls43_t3_l3' or @xml:id='ls43_t3_l4' or @xml:id='ls43_t4_l1' or @xml:id='ls43_t4_l2' or @xml:id='ls43_t4_l3' or @xml:id='ls43_t4_l4' or @xml:id='ls43_t4_l5' or @xml:id='ls43_t4_l6' or @xml:id='ls43_t4_l7' or @xml:id='ls43_t5_l1' or @xml:id='ls43_t5_l2' or @xml:id='ls43_t5_l3' or @xml:id='ls43_t5_l4' or @xml:id='ls43_t5_l5' or @xml:id='ls43_t5_l6' or @xml:id='ls43_t5_l7' or @xml:id='ls43_t5_l8' or @xml:id='ls43_t5_l9' or @xml:id='ls43_t5_l10' or @xml:id='ls43_t5_l11' or @xml:id='ls43_t5_l12' or @xml:id='ls43_t5_l13' or @xml:id='ls43_t5_l14' or @xml:id='ls43_t6_l1' or @xml:id='ls43_t6_l2' or @xml:id='ls43_t6_l3' or @xml:id='ls43_t6_l4' or @xml:id='ls43_t7_l1' or @xml:id='ls43_t7_l2' or @xml:id='ls43_t7_l3' or @xml:id='ls43_t7_l4' or @xml:id='ls43_t7_l5' or @xml:id='ls43_t7_l6' or @xml:id='ls43_t7_l7' or @xml:id='ls43_t8_l1' or @xml:id='ls43_t8_l2' or @xml:id='ls43_t9_l1' or @xml:id='ls43_t9_l2' or @xml:id='ls43_t9_l3']", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})

message_intro = "Hello, I hope that you are well! I need your help with the following task: I have a list of talks from Digital Humanities lecture series and I need keywords that describe what each talk is about. I can give you the title and an abstract of each talk. In some cases, there is only a title and the abstract is 'not found'. In such cases, please give me the keywords based on the title alone. Please return a list of five keywords for every talk that I give to you. Please do not use the keyword 'digital humanities', as all the talks are from that field. The talks are in different languages. However, please return English keywords, not keywords in the original language of the talk if it is not English. Please use American English. Please return only the keywords in one line (no additional comments), separated by comma and with a whitespace after each comma (not before the comma). Please return the words in lower-case. Here is the first talk:"

root = etree.Element("responses")
n = 0

for lecture in lectures:
	title = lecture.xpath("tei:eventName[1]/text()", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})
	title = re.sub(r"\s+", " ", title[0])
	abstract = lecture.xpath("tei:note[@type='abstract']//text()", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})
	abstract = " ".join(abstract)
	abstract = re.sub(r"\s+", " ", abstract)
	xml_id = lecture.xpath("@xml:id", namespaces={"tei":"http://www.tei-c.org/ns/1.0"})
	
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
