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
      tf_idfs[word] ||= word.tf_idf
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
