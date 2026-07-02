
# DH as linked communities
This directory contains the data related to the conference contribution "DH as Linked Communities: A Comparison of Participants at Annual Conferences and in Lecture Series in Germany, Austria, and Switzerland", which will be presented as a paper at the conference EADH2026 in Krakow.

In the paper, we compare contributors to the annual conference of the association Digital Humanities in German-speaking Countries (DHd) with those participating in a selected set of DH lecture series that have taken place in Germany, Austria, and Switzerland.

To produce the result data contained in this directory, the following scripts were run:

- https://github.com/erre1998/lectures-that-link/blob/main/scripts/dhd_csv_to_xml.py (to convert CSV files with metadata of DHd conferences to an XML format that can be further processed)
- https://github.com/erre1998/lectures-that-link/blob/main/scripts/extract-md-from-dhd-abstracts.xsl (to extract metadata of DHd conferences from TEI files to an XML format that can be further processed)

The results of these data conversions were collected in the following file:

- https://github.com/erre1998/lectures-that-link/blob/main/analyses/contribution-eadh2026/dhd-conference-data.xml

That file was then analyzed with the following scripts:
- https://github.com/erre1998/lectures-that-link/blob/main/scripts/analyze-speakers-dhd-ls.xsl
- https://github.com/erre1998/lectures-that-link/blob/main/scripts/compare-persons-dhd-abstracts.xsl

The resulting files can be found in the current directory.
