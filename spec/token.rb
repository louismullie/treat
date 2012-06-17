#encoding: utf-8
require_relative '../lib/treat'

describe Treat::Entities::Token do

  describe "Buildable" do

    describe "#build" do

      context "when supplied with a word" do
        it "creates a word with the text" do
          t = Treat::Entities::Token.build('word')
          t.should be_an_instance_of Treat::Entities::Word
          t.to_s.should eql 'word'
        end
      end

      context "when supplied with a number or a string representing a numerical quantity" do
        it "creates a number" do
          t = Treat::Entities::Token.build(2)
          t2 = Treat::Entities::Token.build(2.2)
          t3 = Treat::Entities::Token.build('2')
          t4 = Treat::Entities::Token.build('2.2')
          t.should be_an_instance_of Treat::Entities::Number
          t2.should be_an_instance_of Treat::Entities::Number
          t3.should be_an_instance_of Treat::Entities::Number
          t4.should be_an_instance_of Treat::Entities::Number
          t.to_i.should eql 2
          t2.to_i.should eql 2
          t3.to_i.should eql 2
          t4.to_i.should eql 2
          t.to_f.should eql 2.0
          t2.to_f.should eql 2.2
          t3.to_f.should eql 2.0
          t4.to_f.should eql 2.2
        end
      end

      context "when supplied with a punctuation character" do
        it "creates a punctuation with the text" do
          t = Treat::Entities::Token.build('.')
          t.should be_an_instance_of Treat::Entities::Punctuation
        end
      end

      context "when supplied with a symbol character" do
        it "creates a symbol with the text" do
          t = Treat::Entities::Token.build('¨')
          t.should be_an_instance_of Treat::Entities::Symbol
        end
      end
      
    end

  end

  describe "Lexicalizable" do

    before do
      @lexicalizers = Treat.languages.
      english.workers.lexicalizers
    end

    describe "#tag" do

      it "returns the tag of the token" do
        @lexicalizers.taggers.each do |t|
          'man'.tag(t).should eql 'NN'
          '2'.tag(t).should eql 'CD'
          '.'.tag(t).should eql '.'
          '$'.tag(t).should eql '$'
        end
      end

    end

    describe "#category" do

      context "when called on a word" do
        it "returns the general part of speech of " +
        "the word as a lowercase symbol" do
          @lexicalizers.categorizers.each do |c|
            'man'.category(c).should eql :noun
          end
        end
      end

      context "when called on a number" do
        it "returns :number" do
          @lexicalizers.categorizers.each do |c|
            '2'.category(c).should eql :number
          end
        end
      end

      context "when called on a punctuation or symbol" do
        it "returns the type of punctuation or symbol" +
        "as a lowercase identifier" do
          @lexicalizers.categorizers.each do |c|
            '$'.category(c).should eql :dollar
            '.'.category(c).should eql :period
          end
        end
      end

    end

  end

end
