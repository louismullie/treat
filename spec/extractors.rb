# encoding: utf-8
module Treat
  module Tests
    class TestExtractors < Test::Unit::TestCase

      def setup
        @time = Treat::Tests::English::Time
        @date = Treat::Tests::English::Date
        @doc = Treat::Tests::English::LongDoc
        @word = Treat::Tests::English::Word
        @col = Treat::Tests::English::Collection
      end

      def test_time
        assert_nothing_raised { @time.time(:nickel) }
      end
      
      def test_date
        assert_equal 2011, @date.date(:chronic).year
        assert_equal 2011, @date.date(:ruby).year
      end

      def test_topic_words
        assert_nothing_raised { @col.topic_words(:lda) }
      end
      
      def test_named_entity
        p = 'Angela Merkel and Nicolas Sarkozy were the first ones to board the p'
        assert_nothing_raised { @doc.named_entity(:stanford) }
      end

      def test_keywords
        assert_nothing_raised do
          topics = @col.topic_words(:lda)
          @doc.keywords(:topics_frequency, :topic_words => topics)
        end
      end

      def test_topics
        assert_nothing_raised { @doc.topics(:reuters) }
      end

      def test_statistics
        @doc.chunk.segment(:tactful).tokenize
        assert_equal 1, @word.frequency_in(:document)
        assert_nothing_raised { @word.tf_idf ; puts @word.tf_idf }
        # assert_nothing_raised { @doc.statistics(:position_in) }
        # assert_nothing_raised { @doc.statistics(:transition_matrix) }
        # assert_nothing_raised { @doc.statistics(:transition_probability) }
      end
      
    end
  end
end
