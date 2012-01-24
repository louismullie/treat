module Treat
  module Tests
    class TestInflectors < Test::Unit::TestCase

      def setup
        @word = Treat::Tests::EnglishWord
        @number = Treat::Tests::Number
        @verb = Treat::Tests::EnglishVerb
        @noun = Treat::Tests::EnglishNoun
      end

      def test_lemmatizers
        # Not implemented yet.
      end

      def test_stemmers
        assert_equal 'run', @word.stem(:porter)
        assert_equal 'run', @word.stem(:porter_c)
        assert_equal 'run', @word.stem(:uea)
      end
    end

    def test_conjugators
      assert_equal 'running', @verb.present_participle
      assert_equal 'run', @verb.infinitive
      assert_equal 'run', @verb.plural
    end

    def test_declensors
      assert_equal 'geese', @noun.plural
    end

    def test_ordinal_and_cardinal_words
      assert_equal 'twenty', @number.cardinal_words
      assert_equal 'twentieth', @number.ordinal_words
    end

  end
end
