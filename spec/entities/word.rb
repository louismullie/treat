require_relative 'helper'

describe Treat::Entities::Word do

  describe "Extractable" do
    describe "#tf_idf" do
      it "returns the TF*IDF score of the word" do
        #c = Treat::Entities::Collection.build(
        #Treat.paths.spec + 'samples/mathematicians')
        #c.do(:chunk, :segment, :tokenize)
        #c.words[30].tf_idf.should eql 0.2231
      end
    end
  end

end
