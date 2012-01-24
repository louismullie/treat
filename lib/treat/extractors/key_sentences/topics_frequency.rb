module Treat
  module Extractors
    module KeySentences
      class TopicsFrequency
        
        def self.key_sentences(entity, options = {})
          options[:threshold] ||= 4
          @@topics = options[:topic_words]
          if Treat::Entities.rank(entity.type) <
            Treat::Entities.rank(:sentence)
            raise Treat::Exception, 'Cannot get the key ' +
            'sentences of an entity smaller than a sentence.'
          else
            sentence_scores = {}
            sentences = []
            entity.each_sentence do |sentence|
              sentence_scores[sentence.id] = score_sentence(sentence)
            end
            sentence_scores.each do |sid, score|
              if score >= options[:threshold]
                s = entity.find(sid)
                s.set :is_key_sentence?, true
                sentences << s
              end
            end
          end
          sentences
        end
        
        def self.score_sentence(sentence)
          sentence.set :topic_score, 0
          sentence.each_word do |word|
            found = false
            @@topics.each do |i, topic_words|
              if topic_words.include?(word.to_s)
                sentence.set :topic_score,
                (sentence.topic_score + 1)
                found = true
              end
            end
            word.set :is_keyword?, found
          end
          sentence.topic_score
        end
        
      end
    end
  end
end
