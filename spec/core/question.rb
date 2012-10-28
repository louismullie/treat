describe Treat::Learning::Question do

  describe "#initialize" do
    context "when supplied with acceptable parameters" do
      it "should give access to the parameters" do
        question = Treat::Learning::Question.new(
        :is_keyword, :word, 0, :continuous)
        question.name.should eql :is_keyword
        question.target.should eql :word
        question.type.should eql :continuous
        question.default.should eql 0
      end
    end
    context "when supplied with wrong parameters" do
      it "should raise an exception" do
        # Name should be a symbol
        expect { Treat::Learning::Question.new(
        nil, :sentence) }.to raise_error
        # Target should be an actual entity type
        expect { Treat::Learning::Question.new(
        :name, :foo) }.to raise_error
        # Distribution type should be continuous or discrete
        expect { Treat::Learning::Question.new(
        :name, :sentence, :nonsense) }.to raise_error
      end
    end
  end

  describe "#==(question)" do
    context "when supplied with an equal question" do
      it "should return true" do
        Treat::Learning::Question.new(
        :is_keyword, :word).
        should == Treat::Learning::Question.new(
        :is_keyword, :word)
        Treat::Learning::Question.new(
        :is_keyword, :word, :continuous).
        should == Treat::Learning::Question.new(
        :is_keyword, :word, :continuous)
        Treat::Learning::Question.new(
        :is_keyword, :word, :continuous, [0, 1]).
        should == Treat::Learning::Question.new(
        :is_keyword, :word, :continuous, [0, 1])
      end
    end
    context "when supplied with a different question" do
      it "should return false" do
        Treat::Learning::Question.new(
        :is_keyword, :word).
        should_not == Treat::Learning::Question.new(
        :is_keyword, :sentence)
        Treat::Learning::Question.new(
        :is_keyword, :word, :continuous).
        should_not == Treat::Learning::Question.new(
        :is_keyword, :word, :discrete)
        Treat::Learning::Question.new(
        :is_keyword, :word, :continuous, [0, 1]).
        should_not == Treat::Learning::Question.new(
        :is_keyword, :word, :continuous, [1, 0])
      end
    end
  end

end