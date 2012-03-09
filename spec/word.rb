require_relative '../lib/treat'

describe Treat::Entities::Word do

  describe "Inflectors" do

    before do
      @inflectors = Treat::Languages::English::Inflectors
    end

    describe "#stem" do

      it "returns the stem of the word" do
        @inflectors[:stem].each do |s|
          'running'.stem(s).should eql 'run'
        end
      end

    end

    describe "#infinitive" do
      it "returns the infinitive form of a verb" do
        @inflectors[:conjugations].each do |c|
          'running'.infinitive(c).should eql 'run'
        end
      end
    end

    # Nil if not verb?
    describe "#present_participle" do
      it "returns the present participle form of a verb" do
        @inflectors[:conjugations].each do |c|
          'running'.infinitive(c).should eql 'run'
        end
      end
    end

    describe "#plural" do
      it "returns the plural form of the word" do
        @inflectors[:declensions].each do |i|
          'inflection'.plural(i).should eql 'inflections'
        end
      end
    end

    describe "#singular" do
      it "returns the plural form of the word" do
        @inflectors[:declensions].each do |i|
          next if i == :linguistics # Fix this
          'inflection'.plural(i).should eql 'inflections'
        end
      end
    end

    describe "#ordinal_form" do
      it "returns the ordinal form of a number" do
        @inflectors[:cardinal_form].each do |o|
          20.cardinal_form.should eql 'twenty'
        end
        @inflectors[:ordinal_form].each do |o|
          20.ordinal_form.should eql 'twentieth'
        end
      end
    end

  end

  describe "Lexicalizers" do

    describe "#synonyms" do
      it "returns the synonyms of the word" do
        
      end
    end

    describe "#antonyms" do

    end

    describe "#hypernyms" do

    end

    describe "#hyponyms" do

    end

  end

end
