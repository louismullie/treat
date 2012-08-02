require 'simplecov'

SimpleCov.start do 
  
  add_filter '/spec/'
  add_filter '/config/'
  
  add_group 'Core', 'treat/core'
  add_group 'Entities', 'treat/entities'
  add_group 'Helpers', 'treat/helpers'
  add_group 'Loaders', 'treat/loaders'
  add_group 'Workers', 'treat/workers'
  
end

require_relative '../lib/treat'

describe Treat::Core::Question do
  
  describe "#initialize" do
    context "when supplied with acceptable parameters" do
      it "should give access to the parameters" do
        question = Treat::Core::Question.new(
        :is_keyword, :word, :continuous, 0, [0, 1])
        question.name.should eql :is_keyword
        question.target.should eql :word
        question.type.should eql :continuous
        question.default.should eql 0
        question.labels.should eql [0, 1]
      end
    end
    context "when supplied with wrong parameters" do
      it "should raise an exception" do
        # Name should be a symbol
        expect { Treat::Core::Question.new(
          nil, :sentence) }.to raise_error
        # Target should be an actual entity type
        expect { Treat::Core::Question.new(
          :name, :foo) }.to raise_error
        # Distribution type should be continuous or discrete
        expect { Treat::Core::Question.new(
          :name, :sentence, :nonsense) }.to raise_error
      end
    end
  end
  
  describe "#==(question)" do
    context "when supplied with an equal question" do
      it "should return true" do
        Treat::Core::Question.new(
        :is_keyword, :word).
        should == Treat::Core::Question.new(
        :is_keyword, :word)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous).
        should == Treat::Core::Question.new(
        :is_keyword, :word, :continuous)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [0, 1]).
        should == Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [0, 1])
      end
    end
    context "when supplied with a different question" do
      it "should return false" do
        Treat::Core::Question.new(
        :is_keyword, :word).
        should_not == Treat::Core::Question.new(
        :is_keyword, :sentence)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous).
        should_not == Treat::Core::Question.new(
        :is_keyword, :word, :discrete)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [0, 1]).
        should_not == Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [1, 0])
      end
    end
  end

end

describe Treat::Core::Export do
  
  describe "#initialize" do
    context "when supplied with acceptable parameters" do
      it "should give access to the parameters" do
        export = Treat::Core::Export.new(:name, 0, "->(e) { e }")
        export.name.should eql :name
        export.default.should eql 0
        export.proc_string.should eql "->(e) { e }"
        export.proc.should be_instance_of Proc
        export.proc.call('x').should eql 'x'
      end
    end
    context "when supplied with wrong parameters" do
      it "should raise an exception" do
        # First argument should be a symbol representing the name of the export.
        expect { Treat::Core::Export.new(nil) }.to raise_error
        # Third argument, if supplied, should be a string that
        # evaluates to a proc (NOT a proc/lambda).
        expect { Treat::Core::Export.new(:name, 0, lambda { x } ) }.to raise_error
        # Third argument should be proper ruby syntax.
        expect { Treat::Core::Export.new(:name, 0, "->(e) { ") }.to raise_error
        # Third argument should evaluate to a proc.
        expect { Treat::Core::Export.new(:name, 0, "2") }.to raise_error
      end
    end
  end
  
  describe "#==(question)" do
    context "when supplied with an equal question" do
      it "should return true" do
        Treat::Core::Export.new(:name).
        should == Treat::Core::Export.new(:name)
        Treat::Core::Export.new(:name, 0).
        should == Treat::Core::Export.new(:name, 0)
        Treat::Core::Export.new(:name, 0, "->(e) { }").
        should == Treat::Core::Export.new(:name, 0, "->(e) { }")
      end
    end
    context "when supplied with a different question" do
      it "should return false" do
        Treat::Core::Export.new(:name).
        should_not == Treat::Core::Export.new(:name2)
        Treat::Core::Export.new(:name, 0).
        should_not == Treat::Core::Export.new(:name, 1)
        Treat::Core::Export.new(:name, 0, "->(e) { }").
        should_not == Treat::Core::Export.new(:name, 0, "->(e) { x }")
      end
    end
  end

end

describe Treat::Core::Problem do
  
  before do 
  end

end

describe Treat::Core::Problem do

  before do 
  end

end

describe Treat::Core::DataSet do
  
  before do 
  end
  
=begin


p = Problem(
  Question(:is_key_sentence, :sentence, false),
  Feature(:word_count, 0)
)

p2 = Problem(
  Question(:is_key_sentence, :sentence, false),
  Feature(:word_count, 0)
)

ds = DataSet(p)

text = Paragraph("Welcome to the zoo! This is a text.")
text2 = Paragraph("Welcome here my friend. This is well, a text.")

text.do :segment, :tokenize
text2.do :segment, :tokenize

ds1 = text.export(p)
ds2 = text2.export(p2)

ds1.merge(ds2)

puts ds1.inspect
=end
end