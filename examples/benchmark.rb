require 'benchmark'
require 'treat'

Benchmark.bmbm do |x|

  Treat.edulcorate

=begin
  # Readers
  x.report("Read:PDF") { doc = Document 'pages/hhmm_article.pdf'; doc.read }
  x.report("Read:TXT") { doc = Document 'pages/kant_short.txt'; doc.read }
  x.report("Read:YAML") { doc = Document 'pages/nanotechnology_article.yml'; doc.read }
  # x.report("Read:XML") { doc = Document 'pages/test.xml'; doc.read }
  x.report("Read:Image") { doc = Document 'pages/novel_page.jpg'; doc.read }
  
  # Read collection of texts.
  coll = Collection 'pages'
  coll.read
=end

  # Processors.
  # x.report("Cluster:LDA") { coll.cluster(:lda) }
  x.report("Chunk:txt ") { text.chunk(:txt) }
  x.report("Segment:punkt ") { text.segment(:punkt) }
  x.report("Segment:tactful ") { text.segment(:tactful) }
  x.report("Segment:stanford ") { text.segment(:stanford) }
  x.report("Tokenize:macintyre ") { text.tokenize(:macintyre) }
  x.report("Tokenize:multilingual "){ text.tokenize(:multilingual) }
  x.report("Tokenize:perl "){ text.tokenize(:perl) }
  x.report("Tokenize:stanford ") { text.tokenize(:stanford) }
  x.report("Parse:enju") { text = text.parse(:enju) }
  # x.report("Parse:stanford") { text = text.parse(:stanford) }
  # x.report("Parse:link") { text = text.parse(:link) }

  doc = Document 'pages/kant_short.txt'
  text = doc.read.text.chunk.segment.tokenize

  # Formatters.
  yaml = nil; xml = nil
  x.report("Serialize:yaml") { yaml = text.serialize(:yaml) }
  x.report("Serialize:xml") { xml = text.serialize(:xml) }
  x.report("Visualize:tree") { text.visualize(:tree) }
  x.report("Visualize:txt") { text.visualize(:txt) }
  # x.report("Visualize:dot") { text.visualize(:dot) }
  # x.report("Visualize:standoff") { text.visualize(:standoff) }
  # x.report("Visualize:simple_html") { text.visualize(:html) }
  # Clean: html

  # Detectors
  x.report("Langugage:what_language ") { text.language(:what_language) }
  x.report("Encoding:r_chardet19 ") { text.encoding(:r_chardet19) }
  x.report("Format:file ") { text.format(:file) }

  # Extractors
  x.report("Date:chronic") { '2007/02/12'.date(:chronic) }
  x.report("Date:ruby") { '2007/02/12'.date(:ruby) }
  x.report("Time:chronic") { '2007/02/12'.time(:chronic) }
  x.report("Topic:reuters") { text.topic }
  x.report("Statistics:frequency:") { text.each_token { |token| token.statistics(:frequency) } }
  # x.report("Statistics:position:") { text.each_token { |token| token.statistics(:position) } }

  # Inflectors
  # x.report("Lemma:elemma") { text.each_word { |word| word.lemma(:elemma) } }
  x.report("Stem:porter_r") { text.each_word { |word| word.stem(:porter) } }
  x.report("Stem:porter_c") { text.each_word { |word| word.stem(:porter_c) } }
  x.report("Stem:uea") { text.each_word { |word| word.stem(:uea) } }
  x.report("Declense:granger") { text.each_word { |word| word.declense(:granger) } }
  # x.report("Inflect:granger") { text.each_noun { |word| word.plural(:granger) } }

  # Statistics
  x.report("Entity:word_count") { text.word_count }

  # puts text.words_with_cat(:noun).inspect

  # Lexicalizers
  x.report("Tag:stanford") { text.each_word { |word| word.tag(:stanford) } }
  # x.report("Tag:brill") { text.each_word { |word| word.tag(:brill) } }
  # x.report("Tag:lingua") { text.each_word { |word| word.tag(:lingua) } }
  # x.report("Lex:wordnet") { text.each_word { |word| word.lex(:wordnet) } }

end
