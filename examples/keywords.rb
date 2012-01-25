require 'benchmark'
require 'treat'

Treat.edulcorate

c = Collection.from_serialized('texts/corpus.yml')

=begin
c.each_text do |t|
  t.chunk.segment.parse(:stanford)
  puts "Done text #{t.id}."
end

c.serialize(:yaml).save("economist/corpus.yml")

=end

topic_words = c.topic_words(
  :lda,
  :topics => 5,
  :words_per_topic => 5,
  :iterations => 20
)
  
c.each_document do |d|
  
  sentences = d.key_sentences(
    :topics_frequency,
    :topic_words => topic_words,
    :threshold => 4
  )

  tm = d.statistics(
    :transition_matrix,
    :features => [:tag],
    :entity_type => :word,
    :condition => lambda do |word|
      word.has?(:is_keyword?) &&
      word.is_keyword?
    end
  )

  sentences.each do |sentence|
    sentence.each_word do |word|
      score = word.statistics(
        :transition_probability,
        :transition_matrix => tm,
        :relationships => [:parent, :left, :right, :children]
      )
      if word.has?(:is_keyword?) && 
         word.is_keyword?
           score += 0.5 
      end
      if score > 1
        puts word.to_s
      end
    end
  end
  
end



Treat.edulcorate
Treat.bin = '/ruby/nat/bin'

c = Collection 'economist'
c.each_document { |doc| doc.chunk.segment.tokenize }

topic_words = c.topic_words(
  :lda,
  :topics => 5,
  :words_per_topic => 5,
  :iterations => 20
)

keywords = c.keywords(
  :topics_frequency,
  :topic_words => topic_words,
  :tf_idf_threshold => 180
)

puts keywords.inspect

abort

c = Phrase 'a test clause'
c.parse
puts c.visualize(:tree)
puts c.visualize(:inspect)
puts c.visualize(:short_value)
puts c.visualize(:standoff)
puts c.visualize(:tree)

c.serialize(:yaml).save('test.yml')
c.serialize(:xml).save('test.xml')

d = Phrase 'test.yml'
d.print_tree
d = Phrase 'test.xml'
d.print_tree

puts d.words[0].position_in_parent
abort

w = Word 'running'
puts w.stem(:porter_c)
puts w.stem(:porter)
puts w.stem(:uea)

w = Word 'run'

puts w.infinitive(:linguistics)
puts w.present_participle(:linguistics)
puts w.plural(:linguistics)

w = Word 'table'

puts w.synonyms.inspect
puts w.antonyms.inspect
puts w.hyponyms.inspect
puts w.hypernyms.inspect

n = Number 2
puts n.ordinal_words(:linguistics)
puts n.cardinal_words(:linguistics)

s = Sentence 'A sentence to parse.'
s.dup.parse(:enju).print_tree
s.dup.parse(:stanford).print_tree

s = Sentence 'A sentence to tokenize'
s.dup.tokenize(:macintyre).print_tree
s.dup.tokenize(:multilingual).print_tree
s.dup.tokenize(:perl).print_tree
s.dup.tokenize(:punkt).print_tree
s.dup.tokenize(:stanford).print_tree
s.dup.tokenize(:tactful).print_tree


=begin
c = Collection 'economist'
# c.each_document { |d| d.chunk.segment.tokenize }
c.documents[0].chunk.segment
c.sentences[0].parse(:enju)
c.each_word { |word| word.stem }
c.visualize(:dot, features: [:tag]).save('test.dot')
=end
