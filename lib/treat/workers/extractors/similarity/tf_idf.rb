# Calculates the TF*IDF score of words.
class Treat::Workers::Extractors::Similarity::TfIdf

  require 'tf-idf-similarity'
  
  def self.similarity(entity, options={})

    raise 'Not currently implemented.'
    
    unless options[:to] && 
           options[:to].type == :document
      raise Treat::Exception, 'Must supply ' +
      'a document to compare to using ' +
      'the option :to for this worker.'
    end
  
    unless options[:to].parent_collection && 
           entity.parent_collection
      raise Treat::Exception, 'The TF*IDF ' +
      'similarity algorithm can only be applied ' +
      'to documents that are inside collections.' 
    end
    
    coll = TfIdfSimilarity::Collection.new
    
    entity.each_document do |doc|
      tdoc = TfIdfSimilarity::Document.new(doc.to_s)
      term_counts = Hash.new(0)
      doc.each_word do |word| 
        val = word.value.downcase
        term_counts[val] ||= 0.0
        term_counts[val] += 1.0
      end
      size = term_counts.values.reduce(:+)
      tdoc.instance_eval do
        @term_counts, @size = term_counts, size
      end
      coll << tdoc
    end
    puts coll.similarity_matrix.inspect
  end

end
