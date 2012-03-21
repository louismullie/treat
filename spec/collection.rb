require_relative '../lib/treat'

describe Treat::Entities::Collection do

  before :all do
    @file = Treat.spec + 'samples/mathematicians'
    @collection = Treat::Entities::Collection.build(@file)
  end


  describe "#<<" do

    context "when supplied with a document" do

      it "copies the document to the collection's folder " +
      "and adds the document object to the collection" do
        f = Treat.spec + 'samples/test'
        ff = '3_2_release_notes.html'
        u = 'http://guides.rubyonrails.org/' + ff
        c = Treat::Entities::Collection.build(f)
        d = Treat::Entities::Document.build(u)
        puts File.join(f, ff)
        c << d
        # FileTest.readable?(File.join(f, ff)).should eql true
        FileUtils.rm_rf(f)
      end

    end

    context "when supplied with anything else" do
      it "adds the object to the collection without " +
      "copying the file to the collection's folder" do
        # TODO
      end
    end

  end

  describe "Buildable" do

    describe "#build" do

      context "when supplied with an existing folder name" do

        it "recursively searches the folder for " +
        "files and opens them into a collection of documents" do
          @collection.size.should eql 6
        end

      end

      context "when supplied a folder name that doesn't exist" do

        it "creates the directory and opens the collection" do
          f = Treat.spec + 'samples/test'
          c = Treat::Entities::Collection.build(f)
          FileTest.directory?(f).should eql true
          c.should be_an_instance_of Treat::Entities::Collection
          FileUtils.rm_rf(f)
        end

      end

    end

  end

  describe "Retrievable" do

    describe "#index" do

      it "indexes the collection and stores the index " +
      "in the folder .index inside the collection's folder " do

        @collection.index
        @collection.index.should eql @file + '/.index'
        FileTest.directory?(@file + '/.index').should eql true

      end

    end

    describe "#search" do

      it "searches an indexed collection for a query " +
      "and returns an array of documents containing a " +
      "match for the given query " do

        docs = @collection.search(:q => 'Newton')
        docs.size.should eql 4
        docs.map { |d| d.chunk.title.to_s }.should
        eql ["Isaac (Sir) Newton (1642-1727)",
          "Gottfried Leibniz (1646-1716)",
          "Leonhard Euler (1707-1783)",
        "Archimedes of Syracuse (287-212 BC)"]

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
