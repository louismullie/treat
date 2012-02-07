module Treat
  module Retrievers
    module Searchers
      class Ferret
        silence_warnings { require 'ferret' }
        require 'find'
        DefaultOptions = {
          :q => '',
          :limit => :all
        }
        def self.search(collection, options = {:query => ''})
          unless collection.has?(:index) && collection.index
            raise Treat::Exception, 'This collection has not been indexed.'
          end
          options = DefaultOptions.merge(options)
          query = options.delete(:q)
          files = {}
          collection.index.search_each(query, options) do |doc, score|
            files[collection.index[doc]['file']] = score
          end
          docs = []
          files.each do |doc, score|
            docs << collection.document_with_file(doc)
          end
          docs
        end
      end
    end
  end
end
