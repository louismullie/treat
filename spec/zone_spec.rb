require_relative '../lib/treat'

describe Treat::Entities::Zone do

  describe "Processors" do
    describe "#segment" do

      it "splits a zone into phrases/sentences and adds them as children of the zone" do
        Treat::Languages::English::Processors[:segmenters].each do |s|
          @paragraph = Treat::Entities::Paragraph.new(
          "This is a first sentence inside the first paragraph. " +
          "This is the second sentence that is inside the paragraph.")
          @paragraph.segment(s)
          @paragraph.children.should eql @paragraph.phrases
          @paragraph.phrases.map { |t| t.to_s }.should
          eql ["This is a first sentence inside the first paragraph.",
          "This is the second sentence that is inside the paragraph."]
        end
      end
    end
  end

end
