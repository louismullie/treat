module Treat
  module Tests
    class TestProcessors < Test::Unit::TestCase
      
      def setup
        @doc = Treat::Tests::EnglishShortDoc 
      end
      
      def test_tokenizers
        assert_nothing_raised { @doc.tokenize(:macintyre) }
        assert_nothing_raised { @doc.tokenize(:multilingual) }
        assert_nothing_raised { @doc.tokenize(:perl) }
        assert_nothing_raised { @doc.tokenize(:punkt) }
        assert_nothing_raised { @doc.tokenize(:stanford, :silence => true) }
        assert_nothing_raised { @doc.tokenize(:tactful) }
      end
      
      def test_segmenters
        assert_nothing_raised { @doc.segment(:punkt) }
        assert_nothing_raised { @doc.segment(:stanford, :silence => true) }
        assert_nothing_raised { @doc.segment(:tactful) }
      end
  
      def test_chunkers
        assert_nothing_raised { @doc.chunk(:txt) }
      end
          
      def test_parsers
        assert_nothing_raised { @doc.segment.parse(:enju) }
        assert_nothing_raised { @doc.segment.parse(:stanford, :silence => true) }
      end
      
    end

  end
end
