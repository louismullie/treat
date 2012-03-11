require_relative '../lib/treat'

describe Treat::Entities::Collection do

  before :all do
    file = Treat.spec + 'samples/mathematicians'
    @collection = Treat::Entities::Collection.build(file)
  end

  describe "Buildable" do

    describe "#build" do

      context "when supplied with a folder name" do

        it "recursively searches the folder for " +
        "files and opens them into a collection of documents" do
          @collection.size.should eql 6
        end

      end

      context "when called with anything else than a readable folder name" do

        it "raises an exception" do
          lambda do
            Treat::Entities::Collection.build('nonexistent')
          end.should raise_error
        end

      end

    end

  end

  describe "Retrievable" do

    describe "#index" do

      it "indexes the collection and stores the index " +
      "in the folder .index inside the collection's folder " do

      end

    end

    describe "#search" do

      it "searches an indexed collection for a query " +
      "and returns a list of documents containing a " +
      "match for the given query " do

      end

    end

  end

  describe "Extractable" do

    describe "#topic_words" do

      it "returns an array of arrays, each representing " +
      "a cluster of words that constitutes a topic in the collection" do
        @collection.topic_words[0][0].should eql 'mathematics'
      end

    end

  end

end
