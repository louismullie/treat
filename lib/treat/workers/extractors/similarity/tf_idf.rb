# Calculates the TF*IDF score of words.
class Treat::Workers::Extractors::Similarity::TfIdf

  require 'tf-idf-similarity'

  @collections = {}
  
  def self.tf_idf(collection, options={})
    coll = TfIdfSimilarity::Collection.new
    collection.each_document do |doc|
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
