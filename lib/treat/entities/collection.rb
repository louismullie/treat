module Treat
  module Entities
    # Represents a collection of texts.
    class Collection < Entity
      # Initialize the collection with a folder
      # containing the texts of the collection.
      def initialize(folder = nil, id = nil)
        super('', id)
        @type = :collection
        if folder
          set :folder, folder
          Dir.glob("#{folder}/*").each do |f|
            next if FileTest.directory?(f)
            self << Document.new(f)
          end
        end
      end
      def type; :collection; end
    end
  end
end
