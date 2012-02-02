module Treat
  module Entities
    # Represents a document.
    class Document < Entity
      def initialize(file = nil, id = nil)
        super('', id)
        set :file, file if file
        @type = :document
      end
    end
  end
end