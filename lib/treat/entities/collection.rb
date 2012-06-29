module Treat::Entities
  # Represents a collection of texts.
  class Collection < Treat::Entities::Entity

    # Initialize the collection with a folder
    # containing the texts of the collection.
    def initialize(folder = nil, id = nil)
      super('', id)
      set :folder, folder
      i = folder + '/.index'
      set :index, i if FileTest.directory?(i)
    end

    # Works like the default <<, but if the
    # file being added is a collection or a
    # document, then copy that collection or
    # document into this collection's folder.
    def <<(entities, copy = true)
      unless entities.is_a? Array
        entities = [entities]
      end
      entities.each do |entity|
        if [:document, :collection].
          include?(entity.type) && copy
          entity = entity.copy_into(self)
        end
      end
      super(entities)
    end
  end
end