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

describe Treat::Core::DataSet do

  before do
    @question = Treat::Core::Question.new(:is_key_sentence, :sentence, :continuous, 0, [0, 1])
    @feature = Treat::Core::Feature.new(:word_count, 0)
    @problem = Treat::Core::Problem.new(@question, @feature)
    @tag = Treat::Core::Tag.new(:paragraph_length, 0,
    "->(e) { e.parent_paragraph.word_count }")
    @paragraph = Treat::Entities::Paragraph.new(
    "Ranga and I went to the store. Meanwhile, Ryan was sleeping.")
    @paragraph.do :segment, :tokenize
      @sentence = @paragraph.sentences[0]
      @data_set = Treat::Core::DataSet.new(@problem)
    end

    describe "#initialize" do
      context "when supplied with a problem" do
        it "should initialize an empty data set" do
          data_set = Treat::Core::DataSet.new(@problem)
          data_set.items.should eql []
          data_set.problem.should eql @problem
        end
      end
      context "when supplied with an improper argument" do
        it "should raise an error" do
          # The argument to initialize should be a Problem.
          expect { data_set = Treat::Core::DataSet.new("foo") }.to raise_error
        end
      end
    end

    describe "#self.build" do

    end

    describe "#==(other_data_set)" do
      context "when supplied with an equivalent data set" do
        it "returns true" do
          data_set1 = Treat::Core::DataSet.new(@problem)
          data_set2 = Treat::Core::DataSet.new(@problem)
          data_set1.should == data_set2
          data_set1 << @sentence
          data_set2 << @sentence
          data_set1.should == data_set2
        end
      end

      context "when supplied with a non-equivalent data set" do
        it "returns false" do
          # Get two slightly different problems.
          question1 = Treat::Core::Question.new(
          :is_key_sentence, :sentence, :continuous, 0, [0, 1])
          question2 = Treat::Core::Question.new(
          :is_key_word, :sentence, :continuous, 0, [1, 1])
          problem1 = Treat::Core::Problem.new(question1, @feature)
          problem2 = Treat::Core::Problem.new(question2, @feature)
          # Then the problems shouldn't be equal anymore.
          problem1.should_not == problem2
          # Create data sets with the different problems.
          data_set1 = Treat::Core::DataSet.new(problem1)
          data_set2 = Treat::Core::DataSet.new(problem2)
          # Then the data sets shouldn't be equal anymore.
          data_set1.should_not == data_set2
          # Create two data sets with the same problems.
          data_set1 = Treat::Core::DataSet.new(@problem)
          data_set2 = Treat::Core::DataSet.new(@problem)
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
          data_set1 = Treat::Core::DataSet.new(@problem)
          data_set2 = Treat::Core::DataSet.new(@problem)
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
          question1 = Treat::Core::Question.new(
          :is_key_sentence, :sentence, :continuous, 0, [0, 1])
          question2 = Treat::Core::Question.new(
          :is_key_word, :sentence, :continuous, 0, [1, 1])
          # Create two problems with the different questions.
          problem1 = Treat::Core::Problem.new(question1, @feature)
          problem2 = Treat::Core::Problem.new(question2, @feature)
          # Create two data sets with the different problems.
          data_set1 = Treat::Core::DataSet.new(problem1)
          data_set2 = Treat::Core::DataSet.new(problem2)
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
          problem = Treat::Core::Problem.new(@question, @feature, @tag)
          data_set = Treat::Core::DataSet.new(problem)
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
          problem = Treat::Core::Problem.new(@question, @feature, @tag)
          data_set = Treat::Core::DataSet.new(problem)
          data_set << @sentence
          data_set.to_marshal(file: 'test.dump')
          Treat::Core::DataSet.from_marshal(
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

    describe "#self.from_marshal" do

    end

  end

  describe Treat::Core::Problem do

    before do
      @question = Treat::Core::Question.new(:is_key_sentence,
      :sentence, :continuous, 0, [0, 1])
      @feature = Treat::Core::Feature.new(:word_count, 0)
      @tag = Treat::Core::Tag.new(:paragraph_length, 0,
      "->(e) { e.parent_paragraph.word_count }")
      @paragraph = Treat::Entities::Paragraph.new(
      "Ranga and I went to the store. Meanwhile, Ryan was sleeping.")
      @paragraph.do :segment, :tokenize
        @sentence = @paragraph.sentences[0]
        @hash = {"question"=>{"name"=>:is_key_sentence, "target"=>:sentence,
        "type"=>:continuous, "default"=>0, "labels"=>[0, 1]}, "features"=>[
        {"proc_string"=>nil, "default"=>0, "name"=>:word_count, "proc"=>nil}],
        "tags"=>[{"proc_string"=>"->(e) { e.parent_paragraph.word_count }",
        "default"=>0, "name"=>:paragraph_length, "proc"=>nil}], "id"=>0}
      end

      describe "#initialize" do
        context "when supplied with proper arguments" do
          it "initializes the problem and gives access to parameters" do
            problem = Treat::Core::Problem.new(@question, @feature, @tag)
            problem.question.should eql @question
            problem.features.should eql [@feature]
            problem.tags.should eql [@tag]
            problem.feature_labels.should eql [@feature.name]
            problem.tag_labels.should eql [@tag.name]
            # ID ???      FIXME
          end
        end
        context "when supplied with unacceptable arguments" do
          it "raises an error" do
            # First argument should be instance of Question.
            expect { Treat::Core::Problem.new('foo') }.to raise_error
            # Arguments >= 2 should be instances of Export.
            expect { Treat::Core::Problem.new(@question, 'foo') }.to raise_error
            # Should have at least one Feature in the arguments.
            expect { Treat::Core::Problem.new(@question, @tag) }.to raise_error
          end
        end
      end

      describe "#==(problem)" do
        context "when supplied with an equal problem" do
          it "should return true" do
            Treat::Core::Problem.new(@question, @feature).
            should == Treat::Core::Problem.new(@question, @feature)
            Treat::Core::Problem.new(@question, @feature, @tag).
            should == Treat::Core::Problem.new(@question, @feature, @tag)
          end
        end
        context "when supplied with a different question" do
          it "should return false" do
            question = Treat::Core::Question.new(:is_key_sentence, :sentence)
            feature = Treat::Core::Feature.new(:word_count, 999)
            tag = Treat::Core::Tag.new(:paragraph_length, 999)
            Treat::Core::Problem.new(@question, @feature).
            should_not == Treat::Core::Problem.new(question, @feature)
            Treat::Core::Problem.new(@question, @feature).
            should_not == Treat::Core::Problem.new(@question, feature)
            Treat::Core::Problem.new(@question, @feature, @tag).
            should_not == Treat::Core::Problem.new(@question, @feature, tag)
          end
        end
      end

      describe "#export_tags(entity)" do
        context "when called on a problem that has tags" do
          context "and called with an entity of the proper type" do
            it "returns an array of the tags" do
              problem = Treat::Core::Problem.new(@question, @feature, @tag)
              problem.export_tags(@sentence).should eql [11]
            end
          end
        end
        context "when called on a problem that doesn't have tags" do
          it "raises an error" do
            problem = Treat::Core::Problem.new(@question, @feature)
            expect { problem.export_tags(@sentence) }.to raise_error
          end
        end
      end

      describe "#export_features(entity, include_answer = true)" do

        context "when called with an entity of the proper type" do
          context "and include_answer is set to true" do
            context "and the answer is already set on the entity" do
              it "returns an array of the exported features, with the answer" do
                problem = Treat::Core::Problem.new(@question, @feature)
                @sentence.set :is_key_sentence, 1
                problem.export_features(@sentence).should eql [7, 1]
              end
            end
            context "and the answer is not already set on the entity" do
              it "returns an array of the exported features, with the question's default answer" do
                problem = Treat::Core::Problem.new(@question, @feature)
                problem.export_features(@sentence).should eql [7, @question.default]
              end
            end
          end
          context "and include_answer is set to false" do
            it "returns an array of the exported features, without the answer" do
              problem = Treat::Core::Problem.new(@question, @feature)
              problem.export_features(@sentence, false).should eql [7]
            end
          end
        end
        context "when supplied with an entity that is not of the proper type" do
          it "raises an error" do
            problem = Treat::Core::Problem.new(@question, @feature)
            word = Treat::Entities::Word.new('test')
            expect { problem.export_features(word) }.to raise_error
          end
        end
      end

      describe "#to_hash" do
        context "when called on a problem" do
          it "returns a hash describing the problem" do
            Treat::Core::Problem.new(@question, @feature, @tag).
            to_hash.tap { |e| e['id'] = 0 }.should eql @hash
          end
        end
      end

      describe "#self.from_hash" do
        context "when called with a hash describing a problem" do
          it "returns a problem based on the hash" do
            problem = Treat::Core::Problem.from_hash(@hash)
            problem.question.name.should eql :is_key_sentence
            problem.question.target.should eql :sentence
            problem.question.type.should eql :continuous
            problem.question.default.should eql 0
            problem.question.labels.should eql [0, 1]
            problem.features[0].proc_string.should eql nil
            problem.features[0].default.should eql 0
            problem.features[0].name.should eql :word_count
            problem.features[0].proc.should eql nil
          end
        end
      end

    end
