module Treat
  module Tests
    class TestLexicalizers < Test::Unit::TestCase
      
      def setup
        @word = Treat::Tests::EnglishWord
        @sentence = Treat::Tests::EnglishSentence.parse
      end
      
      def test_category
        assert_equal :verb, @word.category(:from_tag)
      end
      
      def test_synsets
        # assert_nothing_raised { @word.synsets(:rita_wn) }
        assert_nothing_raised { @word.synsets(:wordnet) }
        assert_nothing_raised { @word.synonyms(:wordnet) }
        assert_nothing_raised { @word.antonyms(:wordnet) }
        assert_nothing_raised { @word.hyponyms(:wordnet) }
        assert_nothing_raised { @word.hypernyms(:wordnet) }
      end
      
      def test_linkages
        assert_nothing_raised { @sentence.linkages(:naive, :linkage => :main_verb) }
        assert_nothing_raised { @sentence.linkages(:naive, :linkage => :subject) }
        assert_nothing_raised { @sentence.linkages(:naive, :linkage => :object) }
        assert_nothing_raised { @sentence.linkages(:naive, :linkage => :patient) }
      end
      
      def test_taggers
        assert_nothing_raised { @word.tag(:brill) }
        assert_nothing_raised { @word.tag(:lingua) }
        assert_nothing_raised { @word.tag(:stanford) }
      end
      
    end

  end
end
