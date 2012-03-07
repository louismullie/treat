require_relative '../lib/treat'

describe Treat::Entities::Entity do

  before do

    @section = Treat::Entities::Section.new
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
    @section << @sentence << [@noun_phrase, @verb_phrase, @dot]
    @noun_phrase << [@det, @adj_phrase, @noun]
    @adj_phrase << @adj
    @verb_phrase << [@aux, @verb]

  end


  describe "Buildable" do

  end


  describe "Checkable" do

  end

  describe "Countable" do

    describe "#position" do

      it "returns the position of the entity in its parent" do
        @noun_phrase.position.should eql 1
        @det.position.should eql 4
      end

    end

    describe "#position_in(parent_type = nil)" do

      it "returns the position of the entity in the first " +
      "ancestor with the specified parent type or the parent if nil" do
        @noun_phrase.position.should eql @noun_phrase.position_in
        @det.position_in(:section).should eql 4
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

    describe "#each_entity(*entity_types) { |entity| ... }" do

      context "when called with no arguments" do
        it "recursively yields each element in the tree, including itself, " +
        "top-down first then left to right" do

          a = []
          @sentence.each_entity do |e|
            a << e
          end

          a.should eql [@sentence, @noun_phrase, @det,
            @adj_phrase, @adj, @noun,
          @verb_phrase, @aux, @verb, @dot]

        end
      end

      context "when called with one or more entity types supplied as lowercase symbols" do
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

    describe "#is_*?" do
      assert_equal true, @sentence.is_sentence?
      assert_equal true, @noun.is_noun?
    end

    describe "#*" do
      assert_equal @sentence, @section.sentence
      assert_equal [@sentence], @section.sentences
      assert_equal 1, @section.sentence_count
    end
    
    assert_equal [@det], @section.words_with_value('The')
    assert_equal [@verb], @section.words_with_tag('VBG')

    assert_equal @noun, @section.noun
    assert_equal [@aux, @verb], @section.verbs
    assert_equal 6, @section.token_count

    @section.each_sentence do |s|
      assert_equal @sentence, s
    end
    @section.each_noun do |n|
      assert_equal @noun, n
    end
    @section.each_with_value('The') do |x|
      assert_equal @det, x
    end

    assert_equal @sentence, @noun.parent_sentence
  end


  describe "Registrable" do

  end



  describe "Stringable" do

    describe "#to_string" do
      it "returns the true text value of the entity or an empty string if it has none" do
        @section.to_string.should eql ''
        @noun.to_string.should eql 'fox'
      end
    end

    describe "#to_s" do
      it "returns the string value of the entity or its full subtree" do
        @section.to_s.should eql 'The lazy fox is running.'
        @noun.to_s.should eql 'fox'
      end
    end

    describe "#inspect" do
      it "returns an informative string concerning the entity" do
        @section.inspect.should be_an_instance_of String
      end
    end

    describe "#short_value" do
      it "returns a shortened version of the entity's string value" do
        @section.short_value.should eql 'The lazy fox is running.'
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
