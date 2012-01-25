module Treat
  module Extractors
    module Statistics
      # "The term count in the given document is simply the 
      # number of times a given term appears in that document. 
      # This count is usually normalized to prevent a bias 
      # towards longer documents (which may have a higher 
      # term count regardless of the actual importance of 
      # that term in the document) to give a measure of the 
      # importance of the term t within the particular document d. 
      # Thus we have the term frequency tf(t,d), defined in the 
      # simplest case as the occurrence count of a term in a document.
      # 
      # The inverse document frequency is a measure of the general 
      # importance of the term (obtained by dividing the total number 
      # of documents by the number of documents containing the term, 
      # and then taking the logarithm of that quotient)."
      #
      # (From Wikipedia)
      class TfIdf
        DefaultOptions = { type: nil }
        def self.statistics(entity, options={})
          tf = entity.frequency_in(:document)
          tf = tf / entity.root.word_count
          d = entity.root.document_count
          i = 0
          entity.root.each_document do |document|
            i += 1 if document.frequency_of(entity.value)
          end
          idf = ::Math.log(d.to_f/(i.to_f + 1)).abs
          tf.to_f/idf.to_f
        end
      end
    end
  end
end
