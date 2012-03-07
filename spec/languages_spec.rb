require_relative '../lib/treat'

describe Treat::Languages do

  describe "#code(language, iso = 2)" do
    
    it "returns the language code given a full-length " +
    "lowercase identifier representing a language, in " +
    "the specified ISO-639 format (1 or 2)" do
      Treat::Languages.code(:english, 2).should eql :eng
      Treat::Languages.code(:english, 1).should eql :en
    end

  end
  
  describe "#describe" do
    it "returns a lowercase identifier representing the " +
    "full name of a language, given its ISO-639-1/2 code." do
      Treat::Languages.describe(:eng).should eql :english
    end
  end

end
