# This retrieves a supplied number of keywords
# by selecting the N words with the highest TF*IDF
# for each document.
class Treat::Extractors::Keywords::TfIdf
  
  # Default options - retrieve 5 keywords.
  DefaultOptions = { :number => 5 }
  
  # Annotate a document with an array containing
  # the N words with the highest TF*IDF in that
  # document,
  def self.keywords(entity, options = {})
    
    options = DefaultOptions.merge(options)
    tf_idfs = {}
    entity.each_word do |word|
      word.check_has(:tf_idf, false)
      tf_idfs[word] ||= word.get(:tf_idf)
    end

    tf_idfs = tf_idfs.
    sort_by {|k,v| v}.reverse

    if tf_idfs.size <= options[:number]
      return tf_idfs
    end
    
    keywords = []
    i = 0
    
    tf_idfs.each do |word|
      
      w = word[0].to_s
      next if keywords.include?(w)

      entity.each_word_with_value(w) do |w2|

        ps = w2.parent_phrase
        
        if ps.has?(:keyword_count)
          ps.set :keyword_count, 
          ps.keyword_count + 1
        else
          ps.set :keyword_count, 1
        end
        ps.set :keyword_density, 
        (ps.keyword_count / ps.size)
      
      end
      
      break if i > options[:number]
      keywords << w
      
      i += 1
    end
    
    keywords
  end
  
end
