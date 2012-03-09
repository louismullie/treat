require_relative '../lib/treat'

describe Treat::Entities::Collection do

  describe "Buildable" do

    describe "#build" do
      
      context "when supplied with a folder name" do
        
        f = Treat.spec + 'samples/mathematicians'
        
        it "recursively searches the folder for " +
        "files and opens them into a collection of documents" do
          c = Treat::Entities::Collection.build(f)
          c.size.should eql 6
        end
        
      end
      
      context "when called with anything else than a folder name" do
        
        it "raises an exception" do
          lambda do
            Treat::Entities::Collection.build('nonexistent')
          end.should raise_error
        end
        
      end
      
    end
  end

end