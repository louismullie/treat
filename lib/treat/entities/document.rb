module Treat
  module Entities
    # Represents a document.
    class Document < Entity
      def initialize(file = nil, id = nil)
        super('', id)
        set :file, file if file
      end
    end
  end
end