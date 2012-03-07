require_relative '../lib/treat'

describe Treat::Entities::Document do

  describe "Processors" do
    
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

      context "when called on an unstructured document" do

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