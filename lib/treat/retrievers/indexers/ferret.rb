module Treat
  module Retrievers
    module Indexers
      class Ferret
        silence_warnings { require 'ferret' }
        require 'find'
        require 'fileutils'
        def self.index(collection, options = {})
          FileUtils.mkdir("#{collection.folder}/.ferret") unless 
          File.readable?("#{collection.folder}/.ferret")
          index = ::Ferret::Index::Index.new(
            :default_field => 'content', 
            :path => "#{collection.folder}/.ferret"
          )
          collection.each_document do |doc|
            index.add_document(
              :file => doc.file, 
              :content => doc.to_s
            )
          end
          index
        end
      end
    end
  end
end
