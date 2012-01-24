module Treat
  module Lexicalizers
    module Synsets
      # Obtain lexical information about a word using the
      # ruby 'wordnet' gem.
      class Wordnet
        # Require the 'wordnet' gem.
        require 'wordnet'
        # Obtain lexical information about a word using the
        # ruby 'wordnet' gem.
        def self.synsets(word, options = nil)
          unless [:noun, :adjective, :verb].include?(word.category)
            return []
          end
          cat = word.category.to_s.capitalize
          index = ::WordNet.const_get(cat + 'Index').instance
          lemma = index.find(word.value.downcase)
          return [] if lemma.nil?
          synsets = []
          lemma.synsets.each { |synset| synsets << Synset.new(synset) }
          synsets
        end
      end
    end
    # An adaptor for synsets used by the Wordnet gem.
    class Synset
      # The POS tag of the word.
      attr_accessor :pos
      # The definition of the synset.
      attr_accessor :definition
      # The examples in the synset.
      attr_accessor :examples
      def initialize(synset)
        @original_synset = synset
        @pos, @definition, @examples = 
        parse_synset(synset.to_s.split(')'))
      end
      def parse_synset(res) 
        pos = res[0][1..-1].strip
        res2 = res[1].split('(')
        res3 = res2[1].split(';')
        1.upto(res3.size-1) do |i|
          res3[i] = res3[i].strip[1..-2]
        end
        definition = res3[0]
        examples = res3[1..-1]
        return pos, definition, examples
      end
      # The words in the synset.
      def words; @original_synset.words; end
      def synonyms; @original_synset.words; end
      # A gloss (short definition with examples)
      # for the synset.
      def gloss; @original_synset.gloss; end
      # The antonym sets of the synset.
      def antonyms; antonym.collect { |a| a.words }; end
      # The hypernym sets of the synset.
      def hypernyms; hypernym.words; end
      # The hyponym sets of the synset.
      def hyponyms; hyponym.collect { |h| h.words }; end
      # Respond to the missing method event.
      def method_missing(sym, *args, &block)
        ret = @original_synset.send(sym)
        if ret.is_a?(::WordNet::Synset)
          Synset.new(ret)
        else
          ret
        end
      end
    end
  end
end
