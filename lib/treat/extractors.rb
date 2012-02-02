module Treat
  # Extractors extract specific information out of texts.
  module Extractors
    # Extracts the time of an object and annotates it
    # with specific information regarding time.
    module Time
      extend Group
      self.type = :annotator
      self.targets = [:phrase]
    end
    # Extract the topic from a text.
    module Topics
      extend Group
      self.type = :annotator
      self.targets = [:document]
    end
    # Extract the keywords from a text.
    module Keywords
      extend Group
      self.type = :annotator
      self.targets = [:document]
    end
    # Extract the topic words from a text.
    module TopicWords
      extend Group
      self.type = :annotator
      self.targets = [:collection]
    end
    # Extract named entities from texts.
    module NamedEntityTag
      extend Group
      self.type = :transformer
      self.targets = [:sentence]
    end
    # Extract named entities from texts.
    module Coreferences
      extend Group
      self.type = :transformer
      self.targets = [:zone]
    end
    # This module should be moved out of here ASAP.
    module Statistics
      extend Group
      self.type = :annotator
      self.targets = [:word]
      self.default = :none
      self.preprocessors = {
        :frequency_in => lambda do |entity, delegate, options|
          options = {parent: delegate}.merge(options)
          entity.statistics(:frequency_in, options)
        end,
        :tf_idf => lambda do |entity, delegate, options|
          entity.statistics(:tf_idf, options)
        end,
        :position_in => lambda do |entity, options|
          entity.statistics(:position_in, options)
        end
      }
    end
    extend Treat::Category
  end
end