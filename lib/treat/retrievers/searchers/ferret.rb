# A simple interface to the Ferret information
# retrieval library, which performs full-text
# search within documents of a collection.
#
# Documentation: 
# http://rubydoc.info/gems/ferret
class Treat::Retrievers::Searchers::Ferret
  
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
  # - (String) :q => a search query.
  # - (Symbol) :limit => number of documents.
  def self.search(collection, options = {})
    
    options = DefaultOptions.merge(options)
    unless collection.has?(:index) &&
      collection.index
      raise Treat::Exception,
      "This collection must be indexed to be searchable."
    end
    unless options[:q]
      raise Treat::Exception,
      'You must set a query by using the :q option.'
    end
    path = "#{collection.folder}/.index"
    unless File.readable?(path)
      raise Treat::Exception,
      "The index at location #{path} cannot be found."
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
      unless doc2
        raise Treat::Exception,
        "Couldn't retrieve indexed " +
        "document with filename #{doc}."
      end
      if options[:callback]
        options[:callback].call(doc2, score)
      end
      docs << doc2
    end
    
    docs
  end
end