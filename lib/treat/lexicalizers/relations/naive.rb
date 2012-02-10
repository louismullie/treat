module Treat
  module Lexicalizers
    module Relations
      class Naive
        # Fix - add options for sentences.
        def self.relations(entity, options = {})
          if options[:linkage] == :is_a ||
            options[:linkage] == :hypernym_of
            
            entity.each_word do |w1|
              hypernyms = []
              entity.each_word do |w2|
                next if w1 == w2
                if w2.hypernyms.include?(w1.value) ||
                  w1.hyponyms.include?(w2.value)
                  hypernyms << w1
                  w2.link(w1, :is_a)
                  w1.link(w2, :hypernym_of)
                end
              end
              w1.set :hypernyms, hypernyms
            end
            
          elsif options[:linkage] == :synonym_of
            
            entity.each_word do |w1|
              synonyms = []
              entity.each_word do |w2|
                next if w1 == w2
                if w2.synonyms.include?(w1.value)
                  synonyms << w1
                  w2.link(w1, :synonym_of)
                  w1.link(w2, :synonym_of)
                end
              end
              w1.set :synonyms, synonyms
            end
  
          elsif options[:linkage] == :antonym_of
            
            entity.each_word do |w1|
              antonyms = []
              entity.each_word do |w2|
                next if w1 == w2
                if w2.antonyms.include?(w1.value)
                  antonyms << w1
                  w2.link(w1, :antonym_of)
                  w1.link(w2, :antonym_of)
                end
              end
              w1.set :antonyms, antonyms
            end
            
          else
            raise Treat::Exception,
            "Invalid linkage option '#{options[:linkage]}'."
          end
          
        end
      end
    end
  end
end
