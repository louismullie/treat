require_relative '../lib/treat'

describe Treat::Entities::Token do

  describe "Buildable" do

    describe "#build" do

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

  describe "Lexicalizable" do

    before do
      @lexicalizers = Treat::Languages::English::Lexicalizers
    end

    describe "#tag" do

      it "returns the tag of the token" do
        @lexicalizers[:tag].each do |t|
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
          @lexicalizers[:category].each do |c|
            'man'.category(c).should eql :noun
          end
        end
      end

      context "when called on a number" do
        it "returns :number" do
          @lexicalizers[:category].each do |c|
            '2'.category(c).should eql :number
          end
        end
      end

      context "when called on a punctuation or symbol" do
        it "returns the type of punctuation or symbol" +
        "as a lowercase identifier" do
          @lexicalizers[:category].each do |c|
            '$'.category(c).should eql :dollar
            '.'.category(c).should eql :period
          end
        end
      end

    end

  end

end
