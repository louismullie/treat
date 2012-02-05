module Treat
  module Extractors
    module Roles
      class Naive
        def self.roles(entity, options = {})
          role = options.delete(:role)
          if role.nil?
            raise Treat::Exception,
            "You must supply the :role option or call #subject, " +
            "#object, #main_verb, #agent, or #patient."
          end
          if !respond_to?(role)
            raise Treat::Exception,
            "No handler to resolve role #{role}."
          end
          self.send(role, entity, options)
        end
        # %%%
        def self.patient(entity, options)
          v = main_verb(entity, options)
          return nil unless (v && v.has?('voice'))
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
          return nil unless (v && v.has?('voice'))
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
          v.dependencies.each do |dependency|
            args << entity.find(dependency.target)
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
          verb.dependencies.each do |dependency|
            args << entity.find(dependency.target)
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
