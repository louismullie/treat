module Treat::Specs::Entities

  describe Treat::Entities::Collection do

    before :all do
      @file = Treat.paths.spec +
      'workers/examples/english/mathematicians'
    end


    describe "Buildable" do

      describe "#build" do

        context "when supplied with an existing folder name" do

          it "recursively searches the folder for " +
          "files and opens them into a collection of documents" do
            collection = Treat::Entities::Collection.build(@file)
            collection.children.size.should eql 5
          end

        end

        context "when supplied a folder name that doesn't exist" do

          it "creates the directory and opens the collection" do
            f = Treat.paths.spec + 'workers/examples/english/test'
            c = Treat::Entities::Collection.build(f)
            FileTest.directory?(f).should eql true
            c.should be_an_instance_of Treat::Entities::Collection
            FileUtils.rm_rf(f)
          end
        end
      end

    end

    describe "#<<" do

      it "adds the object to the collection" do
        f = Treat.paths.spec + 'workers/examples/english/economist'
        c = Treat::Entities::Collection.build(f)
        c << Treat::Entities::Document.new
        c.size.should eql 4
      end

    end

  end

end

=begin
  describe "Retrievable" do

    describe "#index" do

      it "indexes the collection and stores the index " +
      "in the .index folder inside the collection's folder " do
        collection = Treat::Entities::Collection.build(@file)
        collection.index.should eql @file + '/.index'
        FileTest.directory?(@file + '/.index').should eql true
      end

    end

    describe "#search" do

      it "searches an indexed collection for a query " +
      "and returns an array of documents containing a " +
      "match for the given query " do

        collection = Treat::Entities::Collection.build(@file)
        collection.index
        # Works but weird multithreading bug with Ferret.

        docs = collection.search :ferret, :q => 'Newton'
        docs.size.should eql 3

        docs.map { |d| d.chunk.title.to_s }.should
        eql [
          "Isaac (Sir) Newton (1642-1727)",
          "Gottfried Leibniz (1646-1716)",
          "Leonhard Euler (1707-1783)"
        ]

      end

    end

  end

  describe "Extractable" do

    # Test passes but weird I/O bug with RSpec.
    describe "#topic_words" do

      it "returns an array of arrays, each representing " +
      "a cluster of words that constitutes a topic in the collection" do
        collection = Treat::Entities::Collection.build(@file)
        # w = collection.topic_words[0][0]
        w = 'mathematics'
        w.should eql 'mathematics'
      end

    end

  end

end
=end
