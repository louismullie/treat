module Treat
  module Tests
    class TestFormatters < Test::Unit::TestCase

      def setup
        @doc = Treat::Tests::EnglishShortDoc
        @html_doc = Treat::Tests::EnglishHtmlDoc
        @sentence = Treat::Tests::EnglishSentence
      end

      def test_readers
        # How should we test this?
      end


      def test_serializers_and_unserializers
        create_temp_file('yml') do |tmp|
          @doc.serialize(:yaml).save(tmp)
          doc = Treat::Entities::Document(tmp)
          assert_equal File.read(tmp).length, 
          doc.serialize(:yaml).length
        end
        create_temp_file('xml') do |tmp|
          @doc.serialize(:xml).save(tmp)
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
