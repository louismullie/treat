module Treat
  module Tests
    class TestLexicalizers < Test::Unit::TestCase
      
      def test_category
        assert_equal :verb, 'visualize'.category(:from_tag, :tagger => :stanford)
        assert_equal :noun, 'inflection'.category(:from_tag, :tagger => :brill)
        assert_equal :adjective, 'sweet'.category(:from_tag, :tagger => :lingua)
      end
      
      def test_synsets
        assert_equal 'mature', 'ripe'.synonyms(:wordnet)[0]
        # assert_equal 'green', ' ripe'.antonyms(:wordnet)[0]
        assert_equal 'beverage', 'coffee'.hypernyms(:wordnet)[0]
        assert_equal 'gravy', 'juice'.hyponyms(:wordnet)[0]
      end
      
      def test_linkages
        sentence = 'Good is bad, but bad is not good'
       # assert_equal sentence.parse(:enju).linkages
      end
      
      def test_taggers
        assert_equal 'VBG', 'running'.tag(:stanford)
        assert_equal 'VBG', 'running'.tag(:brill)
        assert_equal 'VBG', 'running'.tag(:lingua)
      end
      
    end

  end
end
