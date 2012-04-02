![Build Status](https://secure.travis-ci.org/louismullie/treat.png) ![Dependency Status](https://gemnasium.com/louismullie/treat.png)

Treat is a toolkit for natural language processing and computational linguistics. It provides a common API for a number of existing tools in C, Ruby and Java for document retrieval, parsing, annotation, and information extraction.

**Resources**

* Read the [latest documentation](http://rubydoc.info/github/louismullie/treat/master/frames).
* See how to [install Treat](https://github.com/louismullie/treat/wiki/Installing-Treat).
* Learn how to [use Treat](https://github.com/louismullie/treat/wiki/Using-Treat).
* Help out by [contributing to the project](https://github.com/louismullie/treat/wiki/Contributing-to-Treat).
* View a list of [papers](https://github.com/louismullie/treat/wiki/Papers) about tools included in this toolkit.
* Open an [issue](https://github.com/louismullie/treat/issues) and get a quick answer.
 
<br>
**Current features**

* Text extractors for PDF, HTML, XML, Word, AbiWord, OpenOffice and image formats (Ocropus)
* Text retrieval with indexation and full-text search (Ferret)
* Text chunkers, sentence segmenters, tokenizers, and parsers for several languages (Stanford & Enju)
* Word inflectors, including stemmers, conjugators, declensors, and number inflection
* Lexical resources (WordNet interface, several POS taggers for English, Stanford taggers for several languages)
* Language, date/time, general topic and keyword extraction
* Simple text statistics (frequency, TF*IDF)
* Serialization of annotated entities to YAML or XML format
* Visualization in ASCII tree, directed graph (DOT) and tag-bracketed (standoff) formats
* Linguistic resources, including full ISO-639-1 and ISO-639-2 support, and tag alignments for several treebanks

<br>
**Caveats/Planned features**

* Some of the highly recursive code in the core Tree and Entity classes needs to be ported to C.
* The few native Ruby statistics algorithms (e.g. TF*IDF) are in desperate need of optimization.
* A fast WordNet API in Java or C needs is lacking.

<br>
**License**

This software is released under the [GPL License](https://github.com/louismullie/treat/wiki/License-Information) and includes software released under the GPL, Ruby, Apache 2.0 and MIT licenses.