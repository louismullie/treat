module Treat::Lexicalizers::Linkages
  
  class Naive

    def self.linkages(entity, options = {})
      s = nil; v = nil; o = nil
      if entity.has?(:main_verb)
        v = entity.get(:main_verb)
      else
        v = main_verb(entity, options)
        entity.set :main_verb, v
        unless (v && v.has?(:voice))
          return Treat::Features::Linkages.new
        end
      end
      if options[:linkage] == :subject
        s = subject(v, options)
        entity.set :subject, s
      elsif
        options[:linkage] == :object
        o = object(v, options)
        entity.set :object, o
      end
      Treat::Features::Linkages.new(s, v, o)
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
      return if verb.has?(:voice) &&
      verb.voice == 'passive'
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
