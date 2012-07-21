# A wrapper for the indexing functions of Ferret,
# a port of the Java Lucene search engine.
# 
# Documentation: 
# http://rubydoc.info/gems/ferret
class Treat::Workers::Retrievers::Indexers::Ferret
  
  # Require Ferret and file utilities.
  silence_warnings { require 'ferret' }
  require 'find'
  require 'fileutils'
  
  # Create a Ferret index for the collection and
  # store the index in the collection, under the
  # path collection-folder/.index
  # 
  # Annotates the collection with the path to the
  # index for future use (e.g. in searching).
  def self.index(collection, options = {})
    
    # FIXME - what if the collection is stored
    # in a database?
    path = "#{collection.folder}/.index"
    return path if FileTest.directory?(path)
    
    begin
      FileUtils.mkdir(path)
    rescue Exception => e
      raise Treat::Exception,
      "Could not create folder for index " +
      "under the collection's folder. " +
      "(#{e.message})."
    end
    
    index = ::Ferret::Index::Index.new(
      :default_field => 'content',
      :path => path
    )
    
    collection.each_document do |doc|
      index.add_document(
        :file => doc.file,
        :content => doc.to_s
      )
    end
    
    path
    
  end
  
end