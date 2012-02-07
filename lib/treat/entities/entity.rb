require 'treat/tree'
require 'treat/feature'
require 'treat/delegatable'
require 'treat/visitable'
require 'treat/registrable'
require 'treat/buildable'
require 'treat/doable'
require 'treat/viewable'
require 'treat/features'

module Treat
  module Entities
    class Entity < Tree::Node
      # A Symbol representing the lowercase version of the class name.
      attr_accessor :type
      # Implements support for #register
      include Registrable
      # Implement support for #accept.
      include Visitable
      # Implement support for #self.add_workers
      extend Delegatable
      # Implement support for #self.from_*
      extend Buildable
      # Implement support for #do.
      include Doable
      # Implement support for to_s, inspect, etc.
      include Viewable
      # Initialize the entity with its value and
      # (optionally) a unique identifier. By default,
      # the object_id will be used as id. Also initialize
      # the token registry in the root node.
      def initialize(value = '', id = nil)
        id ||= object_id
        super(value, id)
        @type = :entity
        # @match_types = Treat::Entities.match_types
      end
      # Catch missing methods to support method-like
      # access to features (e.g. entity.categoryinstead of
      # entity.features[:cat]) and to support magic
      # methods (see #parse_magic_method). If the
      # feature does not exist
      def method_missing(sym, *args, &block)
        return self.build(*args) if sym == nil
        if !@features.has_key?(sym)
          r = parse_magic_method(sym, *args, &block)
          if r == :no_magic
            begin
              super(sym, *args, &block)
            rescue NoMethodError
              return false if sym.to_s[-1] == '?'
              if Categories.lookup(sym)
                msg = "Method #{sym} cannot be called on a #{type}."
              else
                msg = "Method #{sym} does not exist."
                msg += did_you_mean?(Category.methods, sym)
              end
              raise Treat::Exception, msg
            end
          else
            r
          end
        else
          @features[sym]
        end
      end
      # Parse "magic methods", which allow the following
      # syntaxes to be used (where 'word' can be replaced
      # by any entity type, e.g. token, zone, etc.):
      #
      # - each_word : iterate over each entity of type word.
      # - words: return an array of words in the entity.
      # - word: return the first word in the entity.
      # - word_count: return the number of words in the entity.
      # - words_with_*(value) (where  is an arbitrary feature):
      #   return the words that have the given feature.
      # - word_with_*(value) : return the first word with
      #   the feature specified by * in value.
      #
      # Also provides magical methods for types of words:
      #
      # - each_noun:
      # - nouns:
      # - noun:
      # - noun_count:
      # - nouns_with_*(value)
      # - noun_with_*(value)
      #
      def parse_magic_method(sym, *args)
        @@entities_regexp ||= "(#{Treat::Entities.list.join('|')})"
        @@cats_regexp ||= "(#{Treat::Languages::WordCategories.join('|')})"
        method = sym.to_s =~ /entities/ ?
        sym.to_s.gsub('entities', 'entitys') :
        method = sym.to_s
        if method =~ /^#{@@entities_regexp}s$/
          a = []
          each_entity($1.intern) { |e| a << e }
          a
        elsif method =~ /^#{@@entities_regexp}$/
          a = []
          each_entity($1.intern) { |e| a << e }
          first_but_warn(a, $1)
        elsif method =~ /^parent_#{@@entities_regexp}$/
          ancestor_with_types($1.intern)
        elsif method =~ /^each_#{@@entities_regexp}$/
          each_entity($1.intern) { |e| yield e }
        elsif method =~ /^#{@@entities_regexp}_count$/
          i = 0
          each_entity($1.intern) { |e| i += 1 }
          i
        elsif method =~ /^#{@@entities_regexp}s_with_([a-z]+)$/
          a = []
          each_entity($1.intern) do |e|
            a << e if e.has?($2.intern) &&
            e.send($2.intern) == args[0]
          end
          a
        elsif method =~ /^#{@@entities_regexp}_with_([a-z]*)$/
          a = []
          each_entity($1.intern) do |e|
            a << e if e.has?($2.intern) &&
            e.send($2.intern) == args[0]
          end
          first_but_warn(a, $1)
        elsif method =~ /^each_with_([a-z]*)$/
          each_entity do |e|
            yield e if e.has?($1.intern) &&
            e.send($1.intern) == args[0]
          end
        elsif method =~ /^each_#{@@cats_regexp}$/
          each_entity(:word) { |e| yield e if e.category == $1.intern }
        elsif method =~ /^#{@@cats_regexp}s$/
          a = []
          each_entity(:word) { |e| a << e if e.category == $1.intern }
          a
        elsif method =~ /^#{@@cats_regexp}$/
          a = []
          each_entity(:word) { |e| a << e if e.category == $1.intern }
          first_but_warn(a, $1)
        elsif method =~ /^#{@@cats_regexp}_count$/
          i = 0
          each_entity(:word) { |e| i += 1 if e.category == $1.intern }
          i
        elsif method =~ /^#{@@cats_regexp}s_with_([a-z]*)$/
          a = []
          each_entity(:word) do |e|
            a << e if e.category == $1.intern &&
            e.has?($2.intern) && e.send($2.intern) == args[0]
          end
          a
        elsif method =~ /^#{@@cats_regexp}_with_([a-z]*)$/
          a = []
          each_entity(:word) do |e|
            a << e if e.category== $1.intern &&
            e.has?($2.intern) && e.send($2.intern) == args[0]
          end
          first_but_warn(a, $1)
        elsif method =~ /^is_#{@@entities_regexp}\?$/
          type.to_s == $1
        elsif method =~ /^is_#{@@cats_regexp}\?$/
          category.to_s == $1
        else
          return :no_magic
        end
      end
      # Add an entity to the current entity.
      # Registers the entity in the root node
      # token registry if the entity is a leaf.
      #
      # @see Treat::Registrable
      def <<(entities, clear_parent = true)
        entities = [entities] unless entities.is_a? Array
        entities.each do |entity|
          if entity.is_a?(Treat::Entities::Token) ||
            entity.is_a?(Treat::Entities::Phrase)
            register_token(entity) unless entity.value == ''
          end
        end
        super(entities)
        @parent.value = '' if has_parent?
        entities[0]
      end
      # Yields each entity of any of the supplied
      # types in the children tree of this Entity.
      # Note that this function is recursive, unlike
      # #each. It does not yield the top element being
      # recursed.
      #
      # This function NEEDS to be ported to C (see source).
      def each_entity(*types)
        types = [:entity] if types.size == 0
        f = false
        types.each { |t2| f = true if Treat::Entities.match_types[type].include?(t2) }
        yield self if f
        unless @children.size == 0
          @children.each do |child|
            child.each_entity(*types) { |y| yield y }
          end
        end
      end

      # Replace with:
      #inline do |builder|
        #  
       # builder.c_raw <<-EOS, :arity => -1



        #EOS
      #end
      # Returns the first ancestor of this entity that has the given type.
      def ancestor_with_types(*types)
        ancestor = @parent
        match_types = lambda do |t1, t2s|
          f = false
          t2s.each do |t2|
            if Treat::Entities.match_types[t2][t1]
              f = true; break
            end
          end
          f
        end
        if ancestor
          while not match_types.call(ancestor.type, types)
            return nil unless (ancestor && ancestor.has_parent?)
            ancestor = ancestor.parent
          end
          match_types.call(ancestor.type, types) ? ancestor : nil
        end
      end
      alias :ancestor_with_type :ancestor_with_types
      # Returns the (direct) ancestors of this entity that
      # have the given type.
      def ancestors_with_types(*types)
        ancestor = self
        ancestors = []
        while (a = ancestor.ancestor_with_types(*types))
          ancestors << a
          ancestor = ancestor.parent
        end
        ancestors
      end
      alias :ancestors_with_type :ancestors_with_types
      # Return the first element in the array, warning if not
      # the only one in the array. Used for magic methods: e.g.,
      # the magic method "word" if called on a sentence
      # with many words, Treat will return the first word
      # but warn the user.
      def first_but_warn(array, type)
        if array.size > 1
          warn "Warning: requested one #{type}, but" +
          " there are many #{type}s in the given entity."
        end
        array[0]
      end
    end
  end
end
