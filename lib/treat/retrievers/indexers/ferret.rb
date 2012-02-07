module Treat
  module Retrievers
    module Indexers
      class Ferret
        silence_warnings { require 'ferret' }
        require 'find'
        require 'fileutils'
        # Create a Ferret index for the collection and
        # store the path to the index under "folder."
        def self.index(collection, options = {})
          path = "#{collection.folder}/.index"
          FileUtils.mkdir(path) unless File.readable?(path)
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
    end
  end
end
