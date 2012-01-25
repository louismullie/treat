module Treat
  module Lexicalizers
    module Linkages
      class Naive
        def self.linkages(entity, options = {})
          linkage = options.delete(:linkage)
          if linkage.nil?
            raise Treat::Exception,
            "You must supply the :linkage option."
          end
          if !respond_to?(linkage)
            raise Treat::Exception,
            "No handler to resolve linkage #{linkage}."
          end
          self.send(linkage, entity, options)
        end
        # %%%
        def self.patient(entity, options)
          # Not so simple here...                 Fix
          if main_verb.has_feature?(:aux)
            subject
          elsif main_verb.voice == 'passive'
            subject
          elsif main_verb.voice == 'active'
            # Each prepos.
          end
        end
        # Return the subject of the sentence|verb.
        def self.subject(entity, options)
          verb = (entity.has?(:category) && entity.category == :verb) ? 
          main_verb(entity) : entity.main_verb
          args = []
          main_verb.edges.each_pair do |id,edge|
            args << find(id)
          end
          args[0]
        end
        # Return the object of the sentence|verb.
        def self.object(entity, options)
          verb = (entity.has?(:category) && entity.category == :verb) ? 
          main_verb(entity) : entity.main_verb
          if verb.voice == 'passive'
            return
          end
          args = []
          verb.edges.each_pair do |id,edge|
            args << find(id)
          end
          args[1]
        end
        # Find the main verb (shallowest verb in the tree).
        def self.main_verb(entity, options)
          verbs = entity.verbs
          if verbs.empty?
            return
          end
          verbs.sort! { |a,b| a.depth <=> b.depth }
          verbs[0]
        end
      end
    end
  end
end
