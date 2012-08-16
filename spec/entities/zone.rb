describe Treat::Entities::Zone do

  describe "Buildable" do

    describe "#build" do

      context "when called with a section of text" do

        it "creates a section with the text" do

          section = "A title\nFollowed by a fake sentence."
          s = Treat::Entities::Zone.build(section)
          s.should be_an_instance_of Treat::Entities::Section

        end

      end

      context "when called with a paragraph of text" do

        it "creates a paragraph with the text" do
          paragraph = "Sentence 1. Sentence 2. Sentence 3."
          p = Treat::Entities::Zone.build(paragraph)
          p.should be_instance_of Treat::Entities::Paragraph
        end

      end

      context "when called with a very short text" do

        it "creates a title with the text" do
          title = "A title!"
          p = Treat::Entities::Zone.build(title)
          p.should be_instance_of Treat::Entities::Title
        end

      end

    end
    
  end

end
