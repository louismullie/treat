describe Treat::Entities::Document do

  describe "Buildable" do

    describe "#build" do

      context "when supplied with a readable file name" do
        it "opens the file and reads its " +
        "content into a document" do
          f = Treat.paths.spec + 'samples/mathematicians/leibniz.txt'
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
          d.format.should eql 'html'
          d.print_tree
          d.should be_an_instance_of Treat::Entities::Document
          d.to_s.index('Rubyist').should_not eql nil
        end
      end

      context "when supplied with a url with no file extension" do
        it "downloads the file the URL points to and opens " +
        "a document with the contents of the file, assuming " +
        "the downloaded file to be in HTML format" do
          url = 'http://www.economist.com/node/21552208'
          d = Treat::Entities::Document.build(url)
          d.should be_an_instance_of Treat::Entities::Document
          d.to_s.index('Ronnie Lupe').should_not eql nil
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
  
end