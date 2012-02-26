module Treat
  module Tests
    class TestEntity < Test::Unit::TestCase
      def setup
        @section = Treat::Entities::Section.new
        @sentence = Treat::Entities::Sentence.new
        @noun_cons = Treat::Entities::Phrase.new
        @noun_cons.set :tag, 'NP'
        @verb_cons = Treat::Entities::Phrase.new
        @verb_cons.set :tag, 'VP'
        @adj_cons = Treat::Entities::Phrase.new
        @adj_cons.set :tag, 'ADJP'
        @det = Treat::Entities::Word.new('The')
        @det.set :category, :determiner
        @det.set :tag, 'DT'
        @det.set :tag_set, :penn
        @adj = Treat::Entities::Word.new('lazy')
        @adj.set :category, :adjective
        @adj.set :tag, 'JJ'
        @adj.set :tag_set, :penn
        @noun = Treat::Entities::Word.new('fox')
        @noun.set :category, :noun
        @noun.set :tag, 'NN'
        @noun.set :tag_set, :penn
        @aux = Treat::Entities::Word.new('is')
        @aux.set :category, :verb
        @aux.set :tag, 'VBZ'
        @aux.set :tag_set, :penn
        @verb = Treat::Entities::Word.new('running')
        @verb.set :category, :verb
        @verb.set :tag, 'VBG'
        @verb.set :tag_set, :penn
        @dot = Treat::Entities::Punctuation.new('.')
        @section << @sentence << [@noun_cons, @verb_cons, @dot]
        @noun_cons << [@det, @adj_cons, @noun]
        @adj_cons << @adj
        @verb_cons << [@aux, @verb]
      end

      def test_viewable
        s = 'Happiness is not an ideal of reason, but of imagination.'.tokenize
        assert_nothing_raised do
          # Return the string value of the sentence.
          s.to_s
          # Return a debug description of the sentence.
          s.inspect
          # Return a shortened version of the Sentence with [...]
          s.short_value
        end
      end

      def test_registrable
        assert_equal @section.registry, @verb.registry
        assert_equal @noun, @section.registry[:id][@noun.id]
        assert_equal [@noun], @section.registry[:type][@noun.type]
      end

      def test_delegatable_visitable
        assert_raise(Treat::Exception) do
          @section.encoding(:nonexistent)
        end
        assert_nothing_raised do
          @section.language
        end
      end

      def test_type
        assert_equal :section, @section.type
      end

      def test_printers
        assert_nothing_raised do
          @section.to_s
          @section.to_string
          @section.short_value
          @section.inspect
        end
      end

      def test_magic_methods

        assert_equal true, @sentence.is_sentence?
        assert_equal true, @noun.is_noun?

        assert_equal @sentence, @section.sentence
        assert_equal [@sentence], @section.sentences
        assert_equal 1, @section.sentence_count

        assert_equal [@det], @section.words_with_value('The')
        assert_equal [@verb], @section.words_with_tag('VBG')

        assert_equal @noun, @section.noun
        assert_equal [@aux, @verb], @section.verbs
        assert_equal 6, @section.token_count

        @section.each_sentence do |s|
          assert_equal @sentence, s
        end
        @section.each_noun do |n|
          assert_equal @noun, n
        end
        @section.each_with_value('The') do |x|
          assert_equal @det, x
        end

        assert_equal @sentence, @noun.parent_sentence
      end

      def test_features
        @verb.set :test, :test
        assert_equal :test,  @verb.test
        assert_raise(Treat::Exception) { @verb.nonexistent }
      end

    end
  end
end
