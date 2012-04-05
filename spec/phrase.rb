require_relative '../lib/treat'

describe Treat::Entities::Phrase do

  describe "Buildable" do

    describe "#build" do

      context "when supplied with a sentence" do

        it "creates a sentence with the text" do
          sentence = "This is a sentence."
          s = Treat::Entities::Phrase.build(sentence)
          s.type.should eql :sentence
          s.to_s.should eql sentence
        end

      end

      context "when supplied with a phrase" do

        it "creates a phrase with the text" do
          phrase = "this is a phrase"
          p = Treat::Entities::Phrase.build(phrase)
          p.type.should eql :phrase
          p.to_s.should eql phrase
        end

      end

    end

  end

  describe "Extractable" do
    
    describe "#named_entity" do
      it "tags the named entity words in the phrase" do
        # Not implemented.
      end
    end
    
    describe "#time" do
      it "returns a DateTime object representing the time in the phrase" do
        Treat::Languages::English::Extractors[:time].each do |e|
          t = 'october 2006'.time(e)
          t.month.should eql 10
        end
      end
    end
  end

  describe "Processable" do

    describe "#tokenize" do

      it "splits a phrase/sentence into tokens and adds them as children of the phrase" do
        Treat::Languages::English::Processors[:tokenizers].each do |t|
          @phrase = Treat::Entities::Phrase.new('a phrase to tokenize')
          @phrase.tokenize(t)
          @phrase.children.should eql @phrase.tokens
          @phrase.tokens.map { |t| t.to_s }.should
          eql ['A', 'sentence', 'to', 'tokenize']
        end
      end

    end

    describe "#parse" do

      it "parses a phrase/sentence into its syntax tree, " +
      "adding nested phrases and tokens as children of the phrase/sentence" do
        Treat::Languages::English::Processors[:parsers].each do |p|
          next #f p == :enju # slow?
          @sentence = Treat::Entities::
          Sentence.new('A sentence to tokenize.')
          @sentence.parse(p)
          @sentence.phrases.map { |t| t.to_s }.should
          eql ["A sentence to tokenize.",
            "A sentence to tokenize.",
            "A sentence", "to tokenize",
          "tokenize"]
        end
      end

    end

  end

  describe "Lexicalizable" do

    before do
      @taggers = Treat::Languages::English::Lexicalizers[:taggers]
    end

    describe "#tag" do

      context "when called on an untokenized phrase" do
        it "returns the tag 'P'" do
          @taggers.each do |t|
            p = 'a phrase'
            p.tag(t)
            p.tag(t).should eql 'P'
          end
        end
      end

      context "when called on an untokenized sentence" do
        it "returns the tag 'S'" do
          @taggers.each do |t|
            s = 'This is a sentence.'
            s.tag(t)
            s.tag.should eql 'S'
          end
        end
      end

      context "when called a tokenized phrase" do
        it "returns the tag 'P' and tags all the phrase's tokens" do
          @taggers.each do |t|
            p = 'a phrase'.to_entity
            p.tokenize
            p.tag(t).should eql 'P'
            p.tokens.map { |t| t.tag }.should
            eql ["DT", "NN"]
          end
        end
      end

      context "when called on a tokenized sentence" do
        it "returns the tag 'S' and tags all the sentence's tokens" do
          @taggers.each do |t|
            s = 'This is a sentence.'.to_entity
            s.tokenize
            s.tag(t).should eql 'S'
            s.tokens.map { |t| t.tag }.should
            eql ["DT", "VBZ", "DT", "NN", "."]
          end
        end
      end

    end

  end

end