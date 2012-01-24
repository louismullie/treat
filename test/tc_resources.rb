module Treat
  module Tests
    class TestResources < Test::Unit::TestCase

      def test_languages
        assert_equal :eng, Treat::Resources::Languages.find(:english, 2)
        assert_equal :en, Treat::Resources::Languages.find(:english, 1)
        assert_equal :english, Treat::Resources::Languages.describe(:eng)
        assert_equal :english, Treat::Resources::Languages.describe(:en)
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
