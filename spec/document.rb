require_relative '../lib/treat'

describe Treat::Entities::Document do

  describe "Extractable" do

    describe "#topics" do

      it "returns a list of general topics the document belongs to" do
        #doc = Treat::Entities::Document.new(
        #Treat.spec + 'samples/mathematicians/archimedes.abw').read(:abw)
        #doc.do(:chunk, :segment, :tokenize)
        #puts doc.topics.inspect
      end

    end

  end

  describe "Buildable" do

    describe "#build" do

      context "when supplied with a readable file name" do
        it "opens the file and reads its " +
        "content into a document" do
          f = Treat.spec + 'samples/mathematicians/leibniz.txt'
          d = Treat::Entities::Document.build(f)
          d.should be_an_instance_of Treat::Entities::Document
          d.to_s.index('Gottfried Leibniz').should_not eql nil
        end
      end

      context "when supplied with a url" do
        it "downloads the file the URL points to and opens " +
        "a document with the contents of the file" do
          url = 'http://www.rubyinside.com/nethttp-cheat-sheet-2940.html'
          d = Treat::Entities::Document.build(url)
          d.should be_an_instance_of Treat::Entities::Document
          d.to_s.index('Rubyist').should_not eql nil
        end
      end

      context "when called with anything else than a " +
      "readable file name or url" do

        it "raises an exception" do
          lambda do
            Treat::Entities::Document.build('nonexistent')
          end.should raise_error
        end

      end

    end

  end

  describe "Processable" do

    describe "#chunk" do

      context "when called on an HTML document" do
        doc = Treat::Entities::Document.new(
        Treat.spec + 'samples/mathematicians/euler.html').read(:html)
        it "splits the HTML document into sections, " +
        "titles, paragraphs and lists" do
          doc.chunk
          doc.title_count.should eql 1
          doc.title.to_s.should eql "Leonhard Euler (1707-1783)"
          doc.paragraph_count.should eql 5
        end

      end

      context "when called on a text document" do

        doc = Treat::Entities::Document.new(Treat.spec +
        'samples/mathematicians/leibniz.txt').read(:txt)
        it "splits the document into titles and paragraphs" do
          doc.chunk
          doc.title_count.should eql 1
          doc.title.to_s.should eql "Gottfried Leibniz (1646-1716)"
          doc.paragraph_count.should eql 6
        end

      end

    end

  end

end