require 'treat/tree'
require 'treat/feature'
require 'treat/delegatable'
require 'treat/visitable'
require 'treat/registrable'
require 'treat/buildable'

module Treat
  module Entities
    class Entity < Tree::Node
      # Implements support for #register
      include Registrable
      # Implement support for #accept.
      include Visitable
      # Implement support for #self.add_delegators
      extend Delegatable
      # Implement support for #self.from_*
      extend Buildable
      # Initialize the document with its filename.
      # Optionally specify a reader to read the file.
      # If +read+ is set to false, the document will
      # not be read automatically; in that case, the
      # method #read must be called on the document
      # object to load it in.
      def self.build(file_or_value = '', id = nil)
        from_anything(file_or_value, id)
      end
      # Initialize the entity with its value and
      # (optionally) a unique identifier. By default,
      # the object_id will be used as id. Also initialize
      # the token registry in the root node.
      def initialize(value = '', id = nil)
        id ||= object_id
        super(value, id)
      end
      # Return a lowercase identifier representing the
      # type of entity (e.g. :word, :token, etc.)
      def type; :"#{cl(self.class).downcase}"; end
      # Catch missing methods to support method-like
      # access to features (e.g. entity.cat instead of
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
              # Check...
              if Categories.have_method?(sym)
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
      # Note that repetition of code in this method
      # (instead of method chaining) is intentional
      # and aims to reduce the number of method
      # dispatches done by Ruby to improve performance.
      def parse_magic_method(sym, *args, &block)
        @@entities_regexp ||= "(#{Treat::Entities.list.join('|')})"
        @@cats_regexp ||= "(#{Treat::Languages::English::Categories.join('|')})"
        method = sym.to_s =~ /entities/ ?
        sym.to_s.gsub('entities', 'entitys'):
        method = sym.to_s
        a = []
        if method =~ /^parent_#{@@entities_regexp}$/           # Optimize all
          self.class.send(:define_method, "parent_#{$1}") do
            ancestor_with_types(:"#{$1}")
          end
          ancestor_with_types(:"#{$1}")
        elsif method =~ /^each_#{@@entities_regexp}$/
          each_entity(:"#{$1}") { |entity| yield entity }
        elsif method =~ /^#{@@entities_regexp}s$/
          each_entity(:"#{$1}") { |e| a << e }
          a
        elsif method =~ /^#{@@entities_regexp}$/
          each_entity(:"#{$1}") { |e| a << e }
          first_but_warn(a, $1)
        elsif method =~ /^#{@@entities_regexp}_count$/
          i = 0
          each_entity(:"#{$1}") { |e| i += 1 }
          i
        elsif method =~ /^#{@@entities_regexp}s_with_([a-z]*)$/
          each_entity(:"#{$1}") do |e|
            a << e if e.has?(:"#{$2}") &&
            e.send(:"#{$2}") == args[0]
          end
          a
        elsif method =~ /^#{@@entities_regexp}s_with_([a-z]*)$/
          each_entity(:"#{$1}") do |e|
            a << e if e.has?(:"#{$2}") &&
            e.send(:"#{$2}") == args[0]
          end
          first_but_warn(a, $1)
        elsif method =~ /^each_with_([a-z]*)$/
          each_entity do |e|
            yield e if e.has?(:"#{$2}") &&
            e.send(:"#{$2}") == args[0]
          end
        elsif method =~ /^each_#{@@cats_regexp}$/
          each_entity(:word) { |e| yield e if e.cat == :"#{$1}" }
        elsif method =~ /^#{@@cats_regexp}s$/
          each_entity(:word) { |e| a << e if e.cat == :"#{$1}" }
          a
        elsif method =~ /^#{@@cats_regexp}$/
          each_entity(:word) { |e| a << e if e.cat == :"#{$1}" }
          first_but_warn(a, $1)
        elsif method =~ /^#{@@cats_regexp}_count$/
          i = 0
          each_entity(:word) { |e| i += 1 if e.cat == :"#{$1}" }
          i
        elsif method =~ /^#{@@cats_regexp}s_with_([a-z]*)$/
          each_entity(:word) do |e|
            a << e if e.cat == :"#{$1}" &&
            e.has?(:"#{$2}") && e.send(:"#{$2}") == args[0]
          end
          a
        elsif method =~ /^#{@@cats_regexp}_with_([a-z]*)$/
          each_entity(:word) do |e|
            a << e if e.cat == :"#{$1}" &&
            e.has?(:"#{$2}") && e.send(:"#{$2}") == args[0]
          end
          first_but_warn(a, $1)
        else
          :no_magic
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
            entity.is_a?(Treat::Entities::Constituent)
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
      def each_entity(*types)
        yield self if match_types(self, types)
        if has_children?
          @children.each do |child|
            child.each_entity(*types) { |y| yield y }
          end
        end
      end
      # Returns the first ancestor of this
      # entity that has the given type.
      def ancestor_with_types(*types)
        ancestor = @parent
        while not match_types(ancestor, types)
          return nil unless ancestor.has_parent?
          ancestor = ancestor.parent
        end
        match_types(ancestor, types) ? ancestor : nil
      end
      alias :ancestor_with_type :ancestor_with_types
      # Return the entity's string value in plain text format.
      def to_string; @value; end
      # An alias for #to_string.
      def to_s; visualize(:txt); end
      alias :to_str :to_s
      # Return an informative string representation of the entity.
      def inspect; visualize(:inspect); end
      # Print out an ASCII representation of the tree.
      def print_tree; puts visualize(:tree); end
      # Return a shortened value of the entity's string value using [...].
      def short_value(ml = 6); visualize(:short_value, :max_length => ml); end
      # Convenience functions. Convenience decorators.
      def frequency_of(word); statistics(:frequency_of, value: word); end
      private
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
      # Cache a list of the type => class relationships.
      @@type_classes = {}
      # Returns true if the node is of the same type or
      # is a subtype of of one of the specified entity types,
      # which are supplied as identifiers rather than classes.
      def match_types(node, entity_types)
        entity_types.each do |type|
          @@type_classes[type] ||= Entities.const_get(cc(type))
          return true if node.is_a? @@type_classes[type]
        end
        false
      end
    end
  end
end
