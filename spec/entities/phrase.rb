require_relative 'helper'

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

end