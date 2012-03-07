module Treat
  module Tests
    class TestEntity < Test::Unit::TestCase
      
      def test_registrable
        assert_equal @section.registry, @verb.registry
        assert_equal @noun, @section.registry[:id][@noun.id]
        assert_equal [@noun], @section.registry[:type][@noun.type]
      end

      def test_delegatable_visitable
        assert_raise(Treat::Exception) do
          @section.encoding(:nonexistent)
        end
        assert_nothing_raised do
          @section.language
        end
      end

      def test_type
        assert_equal :section, @section.type
      end

      def test_printers
        assert_nothing_raised do
          @section.to_s
          @section.to_string
          @section.short_value
          @section.inspect
        end
      end

      def test_features
        @verb.set :test, :test
        assert_equal :test,  @verb.test
        assert_raise(Treat::Exception) { @verb.nonexistent }
      end

    end
    
  end
  
end