module Treat
  module Tests
    class TestProcessors < Test::Unit::TestCase
      
      def setup
        @doc = Treat::Tests::English::ShortDoc 
      end
      
      def test_tokenizers
        words = ['A', 'sentence', 'to', 'tokenize']
        tokenize_map = lambda do |worker, o={}|
          'A sentence to tokenize'.
          tokenize(worker, o).words.map { |w| w.value }
        end
        assert_equal words, tokenize_map.call(:macintyre)
        assert_equal words, tokenize_map.call(:multilingual)
        assert_equal words, tokenize_map.call(:perl)
        assert_equal words, tokenize_map.call(:punkt)
        assert_equal words, tokenize_map.call(:stanford, :silence => true)
        assert_equal words, tokenize_map.call(:tactful)
      end
      
      def test_segmenters
        sentences = ['This is sentence 1.', 'This is sentence 2.']
        segment_map = lambda do |worker,o={}| 
          'This is sentence 1. This is sentence 2.'.
          segment(worker, o).sentences.map { |s| s.value }
        end
        assert_equal sentences, segment_map.call(:punkt)
        assert_equal sentences, segment_map.call(:stanford, :silence => true)
        assert_equal sentences, segment_map.call(:tactful)
      end
  
      def test_chunkers
        title = 'This is a title!'
        paragraph = 'This is sentence 1. This is a potential sentence inside a pargraph describing the wonders of the world.'
        s = "This is a title!\nThis is sentence 1. This is a potential sentence inside a pargraph describing the wonders of the world.".chunk
        assert_equal title, s.title.value
        assert_equal paragraph, s.paragraph.value
      end
          
      def test_parsers
        assert_nothing_raised { @doc.segment.parse(:enju) }
        assert_nothing_raised { @doc.segment.parse(:stanford, :silence => true) }
      end
      
    end

  end
end
