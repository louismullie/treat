# Extracts an arbitrary number of keywords from a
# document in a collection by selecting its N words
# with the highest TF*IDF score.
class Treat::Workers::Extractors::Keywords::TfIdf
  
  # Default options - retrieve 5 keywords.
  DefaultOptions = { :number => 5 }
  
  # Annotate a document with an array containing
  # the N words with the highest TF*IDF in that
  # document.
  def self.keywords(entity, options = {})
    
    options = DefaultOptions.merge(options)
    tf_idfs = {}
    
    entity.each_word do |word|
      tf_idf = word.tf_idf
      if tf_idf
        tf_idfs[word] ||= tf_idf 
      end
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
      break if i > options[:number]
      keywords << w
      
      i += 1
    end
    
    entity.each_word do |word|
      
      if keywords.include?(word.to_s)
        word.set :keyword, true
        pp = entity.parent_phrase
      else
        word.set :keyword, false
      end
      
    end
    
    keywords
    
  end
  
end
