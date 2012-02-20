# Retrieves the hypernym, synonym and antonym
# relations between words inside a sentence.
class Treat::Lexicalizers::Relations::Naive
  
  # Fix - add options for sentences.
  def self.relations(entity, options = {})
    
    if options[:linkage] == :is_a ||
      options[:linkage] == :hypernym_of

      entity.each_word do |w1|
        hypernyms = []
        entity.each_word do |w2|
          
          next if w1 == w2
          
          h2 = w2.check_has(:hypernyms)
          h1 = w1.check_has(:hyponyms)
          
          if h2.include?(w1.value) ||
            h1.include?(w2.value)
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
          s = w2.check_has(:synonyms)
          if s.include?(w1.value)
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
          a = entity.check_has(:antonyms)
          if a.include?(w1.value)
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
