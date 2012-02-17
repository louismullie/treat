module Treat
  module Tests
    class TestFormatters < Test::Unit::TestCase

      def setup
        @doc = Treat::Tests::English::ShortDoc
        @sentence = Treat::Tests::English::Sentence
      end

      def test_readers
        # This is done by loading a collection with all types of texts.
      end

      def test_serializers_and_unserializers
        # Test roundtrip Ruby -> YAML -> Ruby -> YAML
        create_temp_file('yml') do |tmp|
          @doc.serialize(:yaml, :file => tmp)
          doc = Treat::Entities::Document(tmp)
          assert_equal File.read(tmp).length, 
          doc.serialize(:yaml).length
        end
        # Test roundtrip Ruby -> XML -> Ruby -> XML.
        create_temp_file('xml') do |tmp|
          @doc.serialize(:xml, :file => tmp)
          doc = Treat::Entities::Document(tmp)
          assert_equal File.read(tmp).length, 
          doc.serialize(:xml).length
        end
      end

      def test_visualizers
        assert_nothing_raised { @doc.visualize(:tree) }
        # assert_nothing_raised { @doc.visualize(:html) }
        assert_nothing_raised { @doc.visualize(:dot) }
        assert_nothing_raised { @doc.visualize(:short_value) }
        assert_nothing_raised { @sentence.visualize(:standoff) }
      end

    end
  end
end
