module Treat::Specs::Learning

  describe Treat::Learning::DataSet do

    before do
      @question = Treat::Learning::Question.new(:is_key_sentence, :sentence, 0, :continuous)
      @feature = Treat::Learning::Feature.new(:word_count, 0)
      @problem = Treat::Learning::Problem.new(@question, @feature)
      @tag = Treat::Learning::Tag.new(:paragraph_length, 0,
      "->(e) { e.parent_paragraph.word_count }")
      @paragraph = Treat::Entities::Paragraph.new(
      "Ranga and I went to the store. Meanwhile, Ryan was sleeping.")
      @paragraph.apply :segment, :tokenize
      @sentence = @paragraph.sentences[0]
      @data_set = Treat::Learning::DataSet.new(@problem)
    end

    describe "#initialize" do
      context "when supplied with a problem" do
        it "should initialize an empty data set" do
          data_set = Treat::Learning::DataSet.new(@problem)
          data_set.items.should eql []
          data_set.problem.should eql @problem
        end
      end
      context "when supplied with an improper argument" do
        it "should raise an error" do
          # The argument to initialize should be a Problem.
          expect { data_set = Treat::Learning::DataSet.new("foo") }.to raise_error
        end
      end
    end

    describe "#self.build" do

    end

    describe "#==(other_data_set)" do
      context "when supplied with an equivalent data set" do
        it "returns true" do
          data_set1 = Treat::Learning::DataSet.new(@problem)
          data_set2 = Treat::Learning::DataSet.new(@problem)
          data_set1.should == data_set2
          data_set1 << @sentence
          data_set2 << @sentence
          data_set1.should == data_set2
        end
      end

      context "when supplied with a non-equivalent data set" do
        it "returns false" do
          # Get two slightly different problems.
          question1 = Treat::Learning::Question.new(
          :is_key_sentence, :sentence, 0,  :continuous)
          question2 = Treat::Learning::Question.new(
          :is_key_word, :sentence, 0, :continuous)
          problem1 = Treat::Learning::Problem.new(question1, @feature)
          problem2 = Treat::Learning::Problem.new(question2, @feature)
          # Then the problems shouldn't be equal anymore.
          problem1.should_not == problem2
          # Create data sets with the different problems.
          data_set1 = Treat::Learning::DataSet.new(problem1)
          data_set2 = Treat::Learning::DataSet.new(problem2)
          # Then the data sets shouldn't be equal anymore.
          data_set1.should_not == data_set2
          # Create two data sets with the same problems.
          data_set1 = Treat::Learning::DataSet.new(@problem)
          data_set2 = Treat::Learning::DataSet.new(@problem)
          # Then these should be equal.
          data_set1.should == data_set2
          # But when different items are added
          data_set1 << Treat::Entities::Sentence.new(
          "This sentence is not the same as the other.").tokenize
          data_set2 << Treat::Entities::Sentence.new(
          "This sentence is similar to the other.").tokenize
          # They shouldn't be equal anymore.
          data_set1.should_not == data_set2
        end
      end

    end

    describe "#merge" do
      context "when supplied with two data sets refering to the same problem" do
        it "merges the two together" do
          # Create two data sets with the same problem.
          data_set1 = Treat::Learning::DataSet.new(@problem)
          data_set2 = Treat::Learning::DataSet.new(@problem)
          # Add a sentence to each data set.
          data_set1 << Treat::Entities::Sentence.new(
          "This sentence is not the same as the other.").tokenize
          data_set2 << Treat::Entities::Sentence.new(
          "This sentence is similar to the other.").tokenize
          # Merge the two data sets together.
          data_set1.merge(data_set2)
          # Check if the merge has occured properly.
          data_set1.items.size.should eql 2
          data_set1.items[1].should eql data_set2.items[0]
        end
      end

      context "when supplied with two data sets refering to different problems" do
        it "raises an error" do
          # Get two slightly different questions.
          question1 = Treat::Learning::Question.new(
          :is_key_sentence, :sentence, 0, :continuous)
          question2 = Treat::Learning::Question.new(
          :is_key_word, :sentence, 0, :continuous)
          # Create two problems with the different questions.
          problem1 = Treat::Learning::Problem.new(question1, @feature)
          problem2 = Treat::Learning::Problem.new(question2, @feature)
          # Create two data sets with the different problems.
          data_set1 = Treat::Learning::DataSet.new(problem1)
          data_set2 = Treat::Learning::DataSet.new(problem2)
          # Add elements to each of the data sets.
          data_set1 << Treat::Entities::Sentence.new(
          "This sentence is not the same as the other.").tokenize
          data_set2 << Treat::Entities::Sentence.new(
          "This sentence is similar to the other.").tokenize
          # Try to merge them; but this should fail.
          expect { data_set1.merge(data_set2) }.to raise_error
        end
      end
    end

    describe "#<<(entity)" do
      context "when supplied with a proper entity" do
        it "exports the features and tags and adds them to the data set" do
          problem = Treat::Learning::Problem.new(@question, @feature, @tag)
          data_set = Treat::Learning::DataSet.new(problem)
          data_set << @sentence
          data_set.items.tap { |e| e[0][:id] = 0 }.
          should eql [{:tags=>[11], :features=>[7, 0], :id=>0}]
        end
      end
    end

    describe "#serialize" do
      context "when asked to use a given adapter" do
        it "calls the corresponding #to_something method" do

        end
      end
    end

    describe "#to_marshal, #self.from_marshal" do
      context "when asked to successively serialize and deserialize data" do
        it "completes a round trip without losing information" do
          problem = Treat::Learning::Problem.new(@question, @feature, @tag)
          data_set = Treat::Learning::DataSet.new(problem)
          data_set << @sentence
          data_set.to_marshal(file: 'test.dump')
          Treat::Learning::DataSet.from_marshal(
          file: 'test.dump').should == data_set
          FileUtils.rm('test.dump')
        end
      end
    end

    describe "#to_mongo" do

    end

    describe "#self.unserialize" do
      context "when asked to use a given adapter" do
        it "calls the corresponding #to_something method" do

        end
      end
    end

    describe "#self.from_mongo" do

    end

  end

end
