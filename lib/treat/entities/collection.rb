module Treat
  module Entities
    # Represents a collection of texts.
    class Collection < Entity
      # Initialize the collection with a folder
      # containing the texts of the collection.
      def initialize(folder = nil)
        super('', id)
        @type = :collection
        set :folder, folder
      end
    end
  end
end
