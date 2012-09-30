describe Treat::Learning::Problem do

  before do
    @question = Treat::Learning::Question.new(:is_key_sentence,
    :sentence, :continuous, 0, [0, 1])
    @feature = Treat::Learning::Feature.new(:word_count, 0)
    @tag = Treat::Learning::Tag.new(:paragraph_length, 0,
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
        problem = Treat::Learning::Problem.new(@question, @feature, @tag)
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
        expect { Treat::Learning::Problem.new('foo') }.to raise_error
        # Arguments >= 2 should be instances of Export.
        expect { Treat::Learning::Problem.new(@question, 'foo') }.to raise_error
        # Should have at least one Feature in the arguments.
        expect { Treat::Learning::Problem.new(@question, @tag) }.to raise_error
      end
    end
  end

  describe "#==(problem)" do
    context "when supplied with an equal problem" do
      it "should return true" do
        Treat::Learning::Problem.new(@question, @feature).
        should == Treat::Learning::Problem.new(@question, @feature)
        Treat::Learning::Problem.new(@question, @feature, @tag).
        should == Treat::Learning::Problem.new(@question, @feature, @tag)
      end
    end
    context "when supplied with a different question" do
      it "should return false" do
        question = Treat::Learning::Question.new(:is_key_sentence, :sentence)
        feature = Treat::Learning::Feature.new(:word_count, 999)
        tag = Treat::Learning::Tag.new(:paragraph_length, 999)
        Treat::Learning::Problem.new(@question, @feature).
        should_not == Treat::Learning::Problem.new(question, @feature)
        Treat::Learning::Problem.new(@question, @feature).
        should_not == Treat::Learning::Problem.new(@question, feature)
        Treat::Learning::Problem.new(@question, @feature, @tag).
        should_not == Treat::Learning::Problem.new(@question, @feature, tag)
      end
    end
  end

  describe "#export_tags(entity)" do
    context "when called on a problem that has tags" do
      context "and called with an entity of the proper type" do
        it "returns an array of the tags" do
          problem = Treat::Learning::Problem.new(@question, @feature, @tag)
          problem.export_tags(@sentence).should eql [11]
        end
      end
    end
    context "when called on a problem that doesn't have tags" do
      it "raises an error" do
        problem = Treat::Learning::Problem.new(@question, @feature)
        expect { problem.export_tags(@sentence) }.to raise_error
      end
    end
  end

  describe "#export_features(entity, include_answer = true)" do

    context "when called with an entity of the proper type" do
      context "and include_answer is set to true" do
        context "and the answer is already set on the entity" do
          it "returns an array of the exported features, with the answer" do
            problem = Treat::Learning::Problem.new(@question, @feature)
            @sentence.set :is_key_sentence, 1
            problem.export_features(@sentence).should eql [7, 1]
          end
        end
        context "and the answer is not already set on the entity" do
          it "returns an array of the exported features, with the question's default answer" do
            problem = Treat::Learning::Problem.new(@question, @feature)
            problem.export_features(@sentence).should eql [7, @question.default]
          end
        end
      end
      context "and include_answer is set to false" do
        it "returns an array of the exported features, without the answer" do
          problem = Treat::Learning::Problem.new(@question, @feature)
          problem.export_features(@sentence, false).should eql [7]
        end
      end
    end
    context "when supplied with an entity that is not of the proper type" do
      it "raises an error" do
        problem = Treat::Learning::Problem.new(@question, @feature)
        word = Treat::Entities::Word.new('test')
        expect { problem.export_features(word) }.to raise_error
      end
    end
  end

  describe "#to_hash" do
    context "when called on a problem" do
      it "returns a hash describing the problem" do
        Treat::Learning::Problem.new(@question, @feature, @tag).
        to_hash.tap { |e| e['id'] = 0 }.should eql @hash
      end
    end
  end

  describe "#self.from_hash" do
    context "when called with a hash describing a problem" do
      it "returns a problem based on the hash" do
        problem = Treat::Learning::Problem.from_hash(@hash)
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