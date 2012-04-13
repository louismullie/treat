class Treat::Dependencies
  
  Gem = [
    ['psych', '1.2.2', '(un)serialize annotated entities to YAML format'],
    ['nokogiri', '>= 1.4.0', 'read and parse XML and HTML formats'],
    ['sdsykes-ferret', '>= 0.11.6.19', 'perform full-text search in collections'],
    ['lda-ruby', '>= 0.3.8', 'extract topic words from documents and collections'],
    ['ruby-readability', '>= 0.5.0', 'extract the readable content from HTML pages'],
    ['stanford-core-nlp', '>= 0.1.8', 'tokenize, segment, parse texts and perform named entity recognition'],
    ['whatlanguage', '>= 1.0.0', 'detect the language of text'],
    ['linguistics', '>= 1.0.9', 'retrieve the inflection of nouns, verbs and numbers in English'],
    ['punkt-segmenter', '>= 0.9.1', 'segment texts into sentences'],
    ['chronic', '>= 0.6.7', 'detect date and time in text'],
    ['decisiontree', '>= 0.3.0', 'perform decision tree classification of text entities'],
    ['ai4r', '>= 1.11', 'perform different kinds of classification tasks on text entities']
  ]
  
  Binary = [
    ['ocropus', 'recognize text in image files'],
    ['antiword', 'extract text from DOC files'],
    ['poppler-utils', 'extract text from PDF files'],
    ['graphviz', 'export and visualize directed graphs']
  ]

end