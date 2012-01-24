module Treat
  module Entities
    # Represents a document.
    class Document < Entity
      def initialize(file, id = nil)
        super('', id)
        set :file, file
      end
    end
  end
end