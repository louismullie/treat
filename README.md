**Fork Changes**
Allow Treat::Core::Installer.install to accept schiphol download options, eg. suppress progress bar for some terminals

[![Build Status](https://secure.travis-ci.org/louismullie/treat.png)](http://travis-ci.org/#!/louismullie/treat)
[![Code Climate](https://codeclimate.com/github/louismullie/treat.png)](https://codeclimate.com/github/louismullie/treat)

![Treat Logo](http://www.louismullie.com/treat/treat-logo.jpg)

**New in v2.0.5: [OpenNLP integration](https://github.com/louismullie/treat/commit/727a307af0c64747619531c3aa355535edbf4632) and [Yomu support](https://github.com/louismullie/treat/commit/e483b764e4847e48b39e91a77af8a8baa1a1d056)**

Treat is a toolkit for natural language processing and computational linguistics in Ruby. The Treat project aims to build a language- and algorithm- agnostic NLP framework for Ruby with support for tasks such as document retrieval, text chunking, segmentation and tokenization, natural language parsing, part-of-speech tagging, keyword extraction and named entity recognition. Learn more by taking a [quick tour](https://github.com/louismullie/treat/wiki/Quick-Tour) or by reading the [manual](https://github.com/louismullie/treat/wiki/Manual).

**Features**

* Text extractors for PDF, HTML, XML, Word, AbiWord, OpenOffice and image formats (Ocropus).
* Text chunkers, sentence segmenters, tokenizers, and parsers (Stanford & Enju).
* Lexical resources (WordNet interface, several POS taggers for English).
* Language, date/time, topic words (LDA) and keyword (TF*IDF) extraction.
* Word inflectors, including stemmers, conjugators, declensors, and number inflection.
* Serialization of annotated entities to YAML, XML or to MongoDB.
* Visualization in ASCII tree, directed graph (DOT) and tag-bracketed (standoff) formats.
* Linguistic resources, including language detection and tag alignments for several treebanks.
* Machine learning (decision tree, multilayer perceptron, LIBLINEAR, LIBSVM).
* Text retrieval with indexation and full-text search (Ferret).

**Contributing**

I am actively seeking developers that can help maintain and expand this project. You can find a list of ideas for contributing to the project [here](https://github.com/louismullie/treat/wiki/Contributing).

**Authors**

Lead developper: @louismullie [[Twitter](https://twitter.com/LouisMullie)]

Contributors:

- @bdigital
- @automatedtendencies
- @LeFnord
- @darkphantum
- @whistlerbrk
- @smileart
- @erol

**License**

This software is released under the [GPL License](https://github.com/louismullie/treat/wiki/License-Information) and includes software released under the GPL, Ruby, Apache 2.0 and MIT licenses.
