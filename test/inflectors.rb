module Treat
  module Tests
    class TestInflectors < Test::Unit::TestCase

      def test_lemmatizers
        # Not implemented yet.
      end

      def test_stemmers
        assert_equal 'run', 'running'.stem(:porter)
        assert_equal 'run', 'running'.stem(:porter_c)
        assert_equal 'run', 'running'.stem(:uea)
      end

      def test_conjugators
        assert_equal 'run', 'running'.infinitive
        assert_equal 'running', 'run'.present_participle
        assert_equal 'run', 'runs'.plural_verb
      end

      def test_declensors
        assert_equal 'inflections', 'inflection'.plural(:linguistics)
        assert_equal 'inflections', 'inflection'.plural(:english)
        assert_equal 'inflection', 'inflections'.singular(:english)
      end

      def test_ordinal_and_cardinal_words
        assert_equal 'twenty', 20.cardinal_words
        assert_equal 'twentieth', 20.ordinal_words
      end

    end
  end
end