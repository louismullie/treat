require_relative '../lib/treat'

describe Treat::Entities::Entity do

  before do

    @paragraph = Treat::Entities::Paragraph.new
    @sentence = Treat::Entities::Sentence.new
    @noun_phrase = Treat::Entities::Phrase.new
    @noun_phrase.set :tag, 'NP'
    @verb_phrase = Treat::Entities::Phrase.new
    @verb_phrase.set :tag, 'VP'
    @adj_phrase = Treat::Entities::Phrase.new
    @adj_phrase.set :tag, 'ADJP'
    @det = Treat::Entities::Word.new('The')
    @det.set :category, :determiner
    @det.set :tag, 'DT'
    @det.set :tag_set, :penn
    @adj = Treat::Entities::Word.new('lazy')
    @adj.set :category, :adjective
    @adj.set :tag, 'JJ'
    @adj.set :tag_set, :penn
    @noun = Treat::Entities::Word.new('fox')
    @noun.set :category, :noun
    @noun.set :tag, 'NN'
    @noun.set :tag_set, :penn
    @aux = Treat::Entities::Word.new('is')
    @aux.set :category, :verb
    @aux.set :tag, 'VBZ'
    @aux.set :tag_set, :penn
    @verb = Treat::Entities::Word.new('running')
    @verb.set :category, :verb
    @verb.set :tag, 'VBG'
    @verb.set :tag_set, :penn
    @dot = Treat::Entities::Punctuation.new('.')
    @dot.set :tag, '.'
    @paragraph << @sentence << [@noun_phrase, @verb_phrase, @dot]
    @noun_phrase << [@det, @adj_phrase, @noun]
    @adj_phrase << @adj
    @verb_phrase << [@aux, @verb]

  end


  describe "Buildable" do

    describe "#build" do

      context "when called on a document" do

        context "when supplied with a file name" do
          it "opens the file and reads its " +
          "content into a document" do
            d = Treat::Entities::Document.build('')
          end
        end

        context "when supplied with a folder name" do
          it "recursively searches the folder for " +
          "files and opens them into a collection of documents" do

          end
        end

        context "when supplied with a url" do
          it "downloads the file the URL points to and opens " +
          "a document with the contents of the file" do

          end
        end

      end

      context "when called on a section of text" do

        context "when supplied with a section of text" do
          it "creates a section with the text" do
            
          end
        end
        
        context "when supplied with anything else" do
          it "raises an error" do
            
          end
        end

      end

      context "when called on a paragraph" do 
        it "creates a paragraph with the text" do

        end
      end

      context "when supplied with a sentence" do
        it "creates a sentence with the text" do

        end
      end

      context "when supplied with a phrase" do
        it "creates a phrase with the text" do

        end
      end

      context "when supplied with a word" do
        it "creates a word with the text" do

        end
      end

      context "when supplied with an integer number" do
        it "creates a number" do

        end
      end

      context "when supplied with a punctuation character" do
        it "creates a punctuation with the text" do

        end
      end

      context "when supplied with a symbol character" do
        it "creates a symbol with the text" do

        end
      end


    end

  end


  describe "Checkable" do

  end

  describe "Countable" do

    describe "#position" do

      it "returns the position of the entity in its parent, sarting at 1" do
        @noun_phrase.position.should eql 1
        @det.position.should eql 1
      end

    end

=begin
    
    describe "#frequency" do

      it "returns the frequency of the entity's value in the root" do
         @det.frequency.should eql 1
      end

    end


    describe "#frequency_in(parent_type = nil)" do

      it "returns the position of the entity's value "+
         "in the supplied parent type, or root if nil" do
           @noun_phrase.frequency_in(:sentence).should eql 1
          
      end
      
    end

=end

  end

  describe "Delegatable" do

  end


  describe "Exportable" do

  end


  describe "Iterable" do

    describe "#each { |child| ... }" do
      it "yields each direct child of a node" do
        a = []
        @sentence.each do |child|
          a << child
        end
        a.should eql [@noun_phrase, @verb_phrase, @dot]
      end
    end

    describe "#each_entity(&entity_types) { |entity| ... }" do

      context "when called with no arguments" do
        it "recursively yields each element in " +
        "the tree, including itself, top-down " +
        "first then left to right" do

          a = []
          @sentence.each_entity do |e|
            a << e
          end

          a.should eql [@sentence, @noun_phrase, @det,
            @adj_phrase, @adj, @noun,
          @verb_phrase, @aux, @verb, @dot]

        end
      end

      context "when called with one or more entity " +
      "types supplied as lowercase symbols" do
        it "recursively yields all elements with the given type(s), "+
        "including the receiver if it matches on of the types" do
          a = []
          @sentence.each_entity(:phrase, :punctuation) do |e|
            a << e
          end
          a.should eql [@sentence, @noun_phrase,
          @adj_phrase, @verb_phrase, @dot]
        end
      end

    end
  end

  describe "Magical" do

    describe "#<entity or word type> - e.g. " +
    "#title, #paragraph, etc. and #adjective, #noun, etc." do

      it "return the first entity with the corresponding " +
      "type inside another entity, but raises an exception "+
      "the type occurs more than once in the entity" do
        @paragraph.sentence.should eql @sentence
      end

    end


    describe "#<entity or word type>s - e.g. " +
    "#sections, #words, etc. and #nouns, #adverbs, etc." do

      it "return an array of the entities with the " +
      "corresponding type in the subtree of an entity" do
        @paragraph.phrases.should eql [@sentence,
        @noun_phrase, @adj_phrase, @verb_phrase]
      end

    end

    describe "#each_<entity type> - e.g. " +
    "#each_sentence, #each_word, etc." do

      it "yields each of the entities with the " +
      "corresponding type in the subtree of an entity" do
        a = []

        @paragraph.each_phrase { |p| a << p }
        a.should eql [@sentence, @noun_phrase,
        @adj_phrase, @verb_phrase]

      end

    end

    describe "#<entity or word type>_count - e.g. " +
    "#sentence_count, #paragraph_count, etc. and " +
    "#noun_count, #verb_count, etc." do

      it "return the number of entities with the" +
      "corresponding type inside another entity" do
        @paragraph.sentence_count.should eql 1
        @paragraph.phrase_count.should eql 4
      end

    end

    describe "#<entity or word type>_with_<feature>(value) - " +
    "e.g. #word_with_id(x) or #adverb_with_value('seemingly')" do

      it "return the entity with the corresponding type " +
      "that have [feature] set to the supplied value; raise" +
      "a warning if there are many entities of that type" do
        @paragraph.word_with_value('The').should eql @det
        @paragraph.token_with_tag('.').should eql @dot
        @sentence.phrase_with_tag('NP').should eql @noun_phrase
      end

    end

    describe "#<entity or word type>s_with_<feature>(value) - " +
    "e.g. #phrases_with_tag('NP'), #nouns_with_value('foo')" do

      it "return an array of the entities with the " +
      "corresponding type that have [feature] set to "+
      "the supplied value" do
        @paragraph.words_with_value('The').should eql [@det]
        @paragraph.tokens_with_tag('.').should eql [@dot]
        @sentence.phrases_with_tag('NP').should eql [@noun_phrase]
      end

    end

    describe "#parent_<entity type> - e.g. " +
    "#parent_document, #parent_collection, etc." do

      it "return the first ancestor of the entity " +
      "that has the supplied type, or nil if none" do
        @sentence.parent_paragraph.should eql @paragraph
        @adj.parent_sentence.should eql @sentence
      end

    end

    describe "#frequency_in_<entity type> - e.g. " +
    "#frequency_in_collection, #frequency_in_document, etc." do

      it "return the frequency of this entity's value " +
      "in the parent entity with the corresponding type" do
        @adj.frequency_in_sentence.should eql 1
      end

    end

  end

  describe "Registrable" do

  end



  describe "Stringable" do

    describe "#to_string" do
      it "returns the true text value of the entity " +
      "or an empty string if it has none" do
        @paragraph.to_string.should eql ''
        @noun.to_string.should eql 'fox'
      end
    end

    describe "#to_s" do
      it "returns the string value of the " +
      "entity or its full subtree" do
        @paragraph.to_s.should
        eql 'The lazy fox is running.'
        @noun.to_s.should eql 'fox'
      end
    end

    describe "#inspect" do
      it "returns an informative string " +
      "concerning the entity" do
        @paragraph.inspect.should
        be_an_instance_of String
      end
    end

    describe "#short_value" do
      it "returns a shortened version of the " +
      "entity's string value" do
        @paragraph.short_value.should
        eql 'The lazy fox is running.'
      end
    end

  end

  describe "Extractors" do

    describe "#language" do
      it "returns the language of an arbitrary entity" do
=begin
        assert_equal Treat.default_language, @doc.language
        Treat.detect_language = true
        assert_equal :eng, @doc.language

        a = 'I want to know God\'s thoughts; the rest are details. - Albert Einstein'
        b = 'El mundo de hoy no tiene sentido, así que ¿por qué debería pintar cuadros que lo tuvieran? - Pablo Picasso'
        c = 'Un bon Allemand ne peut souffrir les Français, mais il boit volontiers les vins de France. - Goethe'
        d = 'Wir haben die Kunst, damit wir nicht an der Wahrheit zugrunde gehen. - Friedrich Nietzsche'

        assert_equal :eng, a.language
        assert_equal :spa, b.language
        assert_equal :fre, c.language
        assert_equal :ger, d.language

        # Reset defaults
        Treat.detect_language = false
=end
      end
    end

  end

end


=begin


def test_visualizers
  assert_nothing_raised { @doc.visualize(:tree) }
  # assert_nothing_raised { @doc.visualize(:html) }
  assert_nothing_raised { @doc.visualize(:dot) }
  assert_nothing_raised { @doc.visualize(:short_value) }
  assert_nothing_raised { @sentence.visualize(:standoff) }
end

=end