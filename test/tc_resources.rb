module Treat
  module Tests
    class TestLanguages < Test::Unit::TestCase

      def test_languages
        assert_equal :eng, Treat::Languages.find(:english, 2)
        assert_equal :en, Treat::Languages.find(:english, 1)
        assert_equal :english, Treat::Languages.describe(:eng)
        assert_equal :english, Treat::Languages.describe(:en)
      end
      
      def test_tags
        
      end
      
      def test_dependencies
        
      end
      
      def test_edges
        
      end
      
    end

  end
end
