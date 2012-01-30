module Treat
  module Tests
    class TestDetectors < Test::Unit::TestCase
      
      def setup
        @doc = Treat::Tests::EnglishLongDoc
      end
      
      def test_format_detectors
        assert_equal :txt, @doc.format
      end
      
      def test_encoding_detectors
        assert_equal :ascii, @doc.encoding(:r_chardet19)
      end
      
      def test_language_detectors
        assert_equal Treat.default_language, @doc.language
        Treat.detect_language = true
        assert_equal :eng, @doc.language
        Treat.detect_language = false
      end
    end

  end
end
