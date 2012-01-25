module Treat
  module Tests
    class TestExtractors < Test::Unit::TestCase

      def setup
        @time = Treat::Tests::EnglishTime
        @date = Treat::Tests::EnglishDate
        @doc = Treat::Tests::EnglishLongDoc
        @word = Treat::Tests::EnglishWord
      end

      def test_time
        assert_nothing_raised { @date.time(:chronic) }
        assert_nothing_raised { @date.time(:native) }
        assert_nothing_raised { @date.time(:nickel) }
      end

      def test_topic_words
        assert_nothing_raised { @doc.topic_words(:lda) }
      end


      def test_named_entity
        # assert_nothing_raised { @doc.named_entity(:stanford) }
        # assert_nothing_raised { @doc.named_entity(:abner) }
      end

      def test_keywords
        assert_nothing_raised do 
          topics = @doc.topic_words(:lda)
          @doc.keywords(:topics_frequency, topic_words: topics)
        end
      end

      def test_topics
        assert_nothing_raised { @doc.topics(:reuters) }
      end

      def test_statistics
        @doc.chunk.segment(:tactful).tokenize

        assert_nothing_raised { @doc.statistics(:frequency_of, value: 'the') }
        assert_nothing_raised { @word.statistics(:frequency_in) }
        # assert_nothing_raised { @doc.statistics(:position_in) }
        # assert_nothing_raised { @doc.statistics(:transition_matrix) }
        # assert_nothing_raised { @doc.statistics(:transition_probability) }
      end
    end
  end
end
