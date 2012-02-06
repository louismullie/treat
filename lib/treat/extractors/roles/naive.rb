module Treat
  module Extractors
    module Roles
      class Naive
        def self.roles(entity, options = {})
          v = main_verb(entity, options)
          return Treat::Features::Roles.new unless (v && v.has?(:voice))
          o = object(v, options)
          s = subject(v, options)
          if v.voice == 'active'
            p = o
          elsif v.voice == 'passive'
            p = s
          elsif v.has_feature?(:aux)
            p = s
          end
          p.set :is_patient?, true if p
          if v.voice == 'active'
            a = s
          elsif v.voice == 'passive'
            #a = object(entity, options)
          end
          a.set :is_agent?, true if a
          if a && p
            a.link(p, :agent_of)
            p.link(a, :patient_of)
          end
          # Fix - s, o, v
          Treat::Features::Roles.new(s, o, v, p, a)
        end
        # Return the subject of the sentence|verb.
        def self.subject(verb, options)
          args = []
          return unless verb
          verb.dependencies.each do |dependency|
            args << verb.root.find(dependency.target)
          end
          s = args[0]
          s.set :is_subject?, true if s
          s
        end
        # Return the object of the sentence|verb.
        def self.object(verb, options)
          return if verb.has?(:voice) && verb.voice == 'passive'
          args = []
          verb.dependencies.each do |dependency|
            args << verb.root.find(dependency.target)
          end
          o = args[1]
          return unless o
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
