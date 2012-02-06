module Treat
  # Extractors extract specific information out of texts.
  module Extractors
    # Detecs language.
    module Language
      extend Group
      require 'treat/extractors/language/language_extractor.rb'
      self.type = :annotator
      self.targets = [:entity]
      self.default = :what_language
    end
    # Extracts the time of an object and annotates it
    # with specific information regarding time.
    module Time
      extend Group
      self.type = :annotator
      self.targets = [:phrase]
    end
    # Extracts the time of an object and annotates it
    # with specific information regarding time.
    module Date
      extend Group
      self.type = :annotator
      self.targets = [:phrase]
    end
    # Extract the topic from a text.
    module Topics
      extend Group
      self.type = :annotator
      self.targets = [:document, :zone]
    end
    # Extract the keywords from a text.
    module Keywords
      extend Group
      self.type = :annotator
      self.targets = [:document, :zone]
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
      self.type = :annotator
      self.targets = [:phrase, :word]
    end
    # Extract named entities from texts.
    module Coreferences
      extend Group
      self.type = :annotator
      self.targets = [:zone]
    end
    # This module should be moved out of here ASAP.
    module Statistics
      extend Group
      self.type = :annotator
      self.targets = [:word]
      self.default = :none
      self.preprocessors = {
        :frequency_in => lambda do |entity, worker, options|
          options = {:parent => worker}.merge(options)
          entity.statistics(:frequency_in, options)
        end,
        :tf_idf => lambda do |entity, worker, options|
          entity.statistics(:tf_idf, options)
        end,
        :position_in => lambda do |entity, options|
          entity.statistics(:position_in, options)
        end
      }
    end
    module Roles
      extend Group
      self.type = :annotator
      self.targets = [:phrase]
    end
    extend Treat::Category
  end
end