module Treat::Entities
  # Represents a document.
  class Document < Treat::Entities::Entity

    def initialize(file = nil, id = nil)
      super('', id)
      set :file, file
    end

  end
end
