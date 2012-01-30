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
        DefaultOptions = {
          type: nil,
          :tf => :standard,
          :idf => :standard,
          :normalization => :none
        }
        Algorithms = {
          tf: {
            standard: lambda { |tf| tf },
            logarithm: lambda { |tf| 1 + Math.log(tf) }
          },
          idf: {
            standard: lambda { |n,df| Math.log(n/(df+1)) },
            none: lambda { |n,idf| 1 }
          },
          normalization: {
            none: lambda { |tf_idf| tf_idf }
          }
        }
        def self.statistics(entity, options={})
          options = DefaultOptions.merge(options)
          lambdas = options.partition do |k,v| 
            [:tf, :idf, :normalization].include?(k)
          end[0]
          lambdas.each do |opt,val|
            if opt.is_a?(Symbol)
              if Algorithms[opt][val]
                options[opt] = Algorithms[opt][val]
              else
                raise Treat::Exception,
                "The specified algorithm '#{val}' "+
                "to calculate #{opt} does not exist."
              end
            end
          end
          tf = options[:tf].call(entity.frequency_in(:document).to_f)
          n = entity.root.document_count
          df = 0
          entity.root.each_document do |document|
            df += 1 if document.frequency_of(entity.value)
          end
          idf = options[:idf].call(n.to_f, df.to_f)
          tf_idf = tf * idf
          tf_idf = options[:normalization].call(tf_idf)
          tf_idf.abs
        end
      end
    end
  end
end
