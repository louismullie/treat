module Treat
  module Retrievers
    module Searchers
      class Ferret
        silence_warnings { require 'ferret' }
        require 'find'
        DefaultOptions = {
          :q => nil,
          :limit => :all,
          :callback => nil
        }
        # Returns an array of retrieved documents.
        #
        # Options:
        #
        # - (String) :q => a search query (aliased as :query).
        # - (Symbol) :limit => number of documents.
        def self.search(collection, options = {})
          options = DefaultOptions.merge(options)
          unless collection.has?(:index) && collection.index
            raise Treat::Exception, 'This collection has not been indexed.'
          end
          options[:q] = options[:query] if options[:query]
          unless options[:q]
            raise Treat::Exception, 
            'You must set a query by using the :q or :query option.'
          end
          path = "#{collection.folder}/.index"
          unless File.readable?(path)
            raise Treat::Exception, "The index at location #{path} cannot be found."
          end
          index = ::Ferret::Index::Index.new(
            :default_field => 'content', 
            :path => path
          )
          query = options.delete(:q)
          files = {}
          index.search_each(query, options) do |doc, score|
            files[index[doc]['file']] = score
          end
          docs = []
          files.each do |doc, score|
            doc2 = collection.document_with_file(doc)
            if options[:callback]
              options[:callback].call(doc, score)
            end
            docs << doc2
          end
          docs
        end
      end
    end
  end
end
