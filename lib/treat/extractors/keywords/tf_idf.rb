# This retrieves a supplied number of keywords
# by selecting the N words with the highest TF*IDF
# for each document.
class Treat::Extractors::Keywords::TfIdf
  
  # Default options - retrieve 5 keywords.
  DefaultOptions = { :num_keywords => 5 }
  
  # Annotate a document with an array containing
  # the N words with the highest TF*IDF in that
  # document,
  def self.keywords(entity, options = {})
    
    options = DefaultOptions.merge(options)
    tf_idfs = {}
    entity.each_word do |word|
      tf_idfs[word.value] ||= word.tf_idf
    end

    tf_idfs = tf_idfs.sort_by {|k,v| v}.reverse

    if tf_idfs.size <= options[:num_keywords]
      return tf_idfs
    end
    
    keywords = []
    i = 0
    tf_idfs.each do |info|
      break if i > options[:num_keywords]
      keywords << info[0]
      i += 1
    end
    
    keywords
  end
  
end
