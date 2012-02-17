require_relative '../lib/treat'

describe Treat::Entities::Entity do

  before do

    @section = Treat::Entities::Section.new
    @sentence = Treat::Entities::Sentence.new
    @noun_cons = Treat::Entities::Phrase.new
    @noun_cons.set :tag, 'NP'
    @verb_cons = Treat::Entities::Phrase.new
    @verb_cons.set :tag, 'VP'
    @adj_cons = Treat::Entities::Phrase.new
    @adj_cons.set :tag, 'ADJP'
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
    @section << @sentence << [@noun_cons, @verb_cons, @dot]
    @noun_cons << [@det, @adj_cons, @noun]
    @adj_cons << @adj
    @verb_cons << [@aux, @verb]

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

  describe "Buildable" do

  end



end
