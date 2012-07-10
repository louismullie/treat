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
    @det.set :category, 'determiner'
    @det.set :tag, 'DT'
    @adj = Treat::Entities::Word.new('lazy')
    @adj.set :category, 'adjective'
    @adj.set :tag, 'JJ'
    @noun = Treat::Entities::Word.new('fox')
    @noun.set :category, 'noun'
    @noun.set :tag, 'NN'
    @aux = Treat::Entities::Word.new('is')
    @aux.set :category, 'verb'
    @aux.set :tag, 'VBZ'
    @verb = Treat::Entities::Word.new('running')
    @verb.set :category, 'verb'
    @verb.set :tag, 'VBG'
    @dot = Treat::Entities::Punctuation.new('.')
    @dot.set :tag, '.'
    @paragraph << @sentence << [@noun_phrase, @verb_phrase, @dot]
    @noun_phrase << [@det, @adj_phrase, @noun]
    @adj_phrase << @adj
    @verb_phrase << [@aux, @verb]

  end


  describe "Checkable" do

    describe "#check_has(feature, do_it = true) " do
      
      it "checks if an entity has the feature; if not, " +
      "calls the default worker to get the feature if do_it " +
      "is set to true; if the entity doesn't have the feature " +
      " and do_it is set to false, it raises an exception." do
        
        # NOT PASSING! Dependence on caller method.

       # lambda {  '$'.to_entity.check_has(:tag, false) }.should raise_error Treat::Exception
 
      end

    end

  end

  describe "Countable" do

    describe "#position" do

      it "returns the position of the entity in its parent, sarting at 0" do
        @noun_phrase.position.should eql 0
        @det.position.should eql 0
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

    describe "#self.call_worker" do

      it "finds the worker class to " +
      "perform a task and delegates the task to it " do

        Treat::Entities::Entity.call_worker(
        '$'.to_entity, :tag, :lingua,
        Treat::Workers::Lexicalizers::Taggers, {}).should
        eql '$'.tag(:lingua)

      end

    end

  end

  describe "Exportable" do

    context "when supplied with a classification to export" do
      classification = Treat::Core::Classification.new(:word, :tag, :is_keyword)
      it "returns a data set with the exported features" do
        ds = @sentence.export(classification)
        ds.classification.should eql classification
        ds.labels.should eql [:tag]
        ds.ids.should eql @sentence.words.map { |w| w.id }
        ds.items.should eql [
          ["DT", false], ["JJ", false],
          ["NN", false], ["VBZ", false],
          ["VBG", false]
        ]
      end
    end

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
          a.should eql [@noun_phrase,
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
        @paragraph.phrases.should eql [@noun_phrase, @adj_phrase, @verb_phrase]
      end

    end

    describe "#each_<entity type> - e.g. " +
    "#each_sentence, #each_word, etc." do

      it "yields each of the entities with the " +
      "corresponding type in the subtree of an entity" do
        a = []

        @paragraph.each_phrase { |p| a << p }
        a.should eql [@noun_phrase,
        @adj_phrase, @verb_phrase]

      end

    end

    describe "#<entity or word type>_count - e.g. " +
    "#sentence_count, #paragraph_count, etc. and " +
    "#noun_count, #verb_count, etc." do

      it "return the number of entities with the " +
      "corresponding type inside another entity" do
        @paragraph.sentence_count.should eql 1
        @paragraph.phrase_count.should eql 3
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
  
  describe "Formatters" do 
    
    
    before do 
      @serializers = Treat.languages.agnostic.
      workers.formatters.serializers
      @txt = "The story of the fox. The quick brown fox jumped over the lazy dog."
    end
    
    describe "#serialize" do

      context "when called with a file to save to" do
        
        it "serializes a document to the supplied format" do
          
          @serializers.each do |ser|
            next if ser == :mongo # Fix this!
            f = Treat.paths.spec + 'test.' + ser.to_s
            s = Treat::Entities::Paragraph.new(@txt)
            s.do(:segment, :tokenize)
            s.serialize(ser, :file => f)
            File.delete(f)
          end
          
        end
        
      end
      
    end
      
    describe "#unserialize" do
      
      context "when called with a serialized file" do
        
        it "reconstitutes the original entity" do
          @serializers.each do |ser|
            next if ser == :mongo # Fix this!
            f = Treat.paths.spec + 'test.' + ser.to_s
            s = Treat::Entities::Paragraph.new(@txt)
          
            s.set :test_int, 9
            s.set :test_float, 9.9
            s.set :test_string, 'hello'
            s.set :test_sym, :hello
            s.set :test_bool, false
            
            s.do(:segment, :tokenize)
            
            s.serialize(ser, :file => f)
            
            d = Treat::Entities::Document.build(f)
          
            d.test_int.should eql 9
            d.test_float.should eql 9.9
            d.test_string.should eql 'hello'
            d.test_sym.should eql :hello
            d.test_bool.should eql false
          
            d.to_s.should eql @txt
            d.size.should eql s.size
          
            d.token_count.should eql s.token_count
            d.tokens[0].id.should eql s.tokens[0].id
          
            File.delete(f)
          end
        
        end
        
      end
      
    end
    
  end

  describe "Extractors" do

    describe "#language" do
      context "when language detection is disabled " +
      "(Treat.core.detect is set to false)" do
        it "returns the default language (Treat.core.language.default)" do
           #Treat.core.language.detect = false
          # Treat.core.language.default = :test
          s = 'Les grands hommes ne sont pas toujours grands, dit un jour Napoleon.'
          # s.language.should eql :test
          # Treat.core.language.default = :english
        end
      end

      context "when language detection is enabled " +
      "(Treat.detect_language is set to true)" do

        it "guesses the language of the entity" do

          Treat.core.language.detect = true
          a = 'I want to know God\'s thoughts; the rest are details. - Albert Einstein'
          b = 'El mundo de hoy no tiene sentido, asi que por que deberia pintar cuadros que lo tuvieran? - Pablo Picasso'
          c = 'Un bon Allemand ne peut souffrir les Francais, mais il boit volontiers les vins de France. - Goethe'
          d = 'Wir haben die Kunst, damit wir nicht an der Wahrheit zugrunde gehen. - Friedrich Nietzsche'
          a.language.should eql :english
          #b.language.should eql :spanish
          #c.language.should eql :french
          #d.language.should eql :german

          # Reset default
          Treat.core.language.detect = false
        end

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
