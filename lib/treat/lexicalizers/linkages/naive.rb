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
          v = main_verb(entity, options)
          return nil unless v
          if v.voice == 'active'
            p = object(entity, options)
          elsif v.voice == 'passive'
            p = subject(entity, options)
          elsif main_verb(entity, options).has_feature?(:aux)
            p = subject(entity, options)
          end
          p.set :is_patient?, true if p
          p
        end
        def self.agent(entity, options)
          v = main_verb(entity, options)
          return nil unless v
          if v.voice == 'active'
            a = subject(entity, options)
          elsif v.voice == 'passive'
           #a = object(entity, options)
          end
          a.set :is_agent?, true if a
          a
        end
        # Return the subject of the sentence|verb.
        def self.subject(entity, options)
          verb = (entity.has?(:category) && entity.category == :verb) ? 
          main_verb(entity) : entity.main_verb
          args = []
          v = main_verb(entity, options)
          return unless v
          v.edges.each_pair do |id,edge|
            args << entity.find(id)
          end
          s = args[0]
          s.set :is_subject?, true if s
          s
        end
        # Return the object of the sentence|verb.
        def self.object(entity, options)
          verb = (entity.has?(:category) && entity.category == :verb) ? 
          main_verb(entity, options) : entity.main_verb
          return if verb.has?(:voice) && verb.voice == 'passive'
          args = []
          verb.edges.each_pair do |id,edge|
            args << entity.find(id)
          end
          o = args[1]
          if o.tag == 'NP'
            b = o
          else
            b = o.phrases_with_tag('NP')[0]
          end
          b.set :is_object?, true if b
          b
        end
        # Find the main verb (shallowest verb in the tree).
        def self.main_verb(entity, options)
          verbs = entity.verbs
          if verbs.size == 0
            return
          end
          verbs.sort! { |a,b| a.depth <=> b.depth }
          v = verbs[0]
          v.set :is_main_verb?, true if v
          v
        end
      end
    end
  end
end
