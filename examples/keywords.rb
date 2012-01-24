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