require_relative '../lib/treat'

describe Treat::Entities::Word do

  describe "Inflectors" do

    before do
      @inflectors = Treat.languages.
      english[:workers][:inflectors]
    end

    describe "#stem" do

      it "returns the stem of the word" do
        @inflectors[:stemmers].each do |s|
          'running'.stem(s).should eql 'run'
        end
      end

    end

    describe "#infinitive" do
      it "returns the infinitive form of a verb" do
        @inflectors[:conjugators].each do |c|
          'running'.infinitive(c).should eql 'run'
        end
      end
    end

    # Nil if not verb?
    describe "#present_participle" do
      it "returns the present participle form of a verb" do
        @inflectors[:conjugators].each do |c|
          'running'.infinitive(c).should eql 'run'
        end
      end
    end

    describe "#plural" do
      it "returns the plural form of the word" do
        @inflectors[:declensors].each do |i|
          # 'inflection'.plural(i).should eql 'inflections'
        end
      end
    end

    describe "#singular" do
      it "returns the singular form of the word" do
        @inflectors[:declensors].each do |i|
          next if i == :linguistics # Fix this
          # 'inflections'.singular(i).should eql 'inflections'
        end
      end
    end

    describe "#ordinal_form" do
      it "returns the ordinal form of a number" do
        @inflectors[:cardinalizers].each do |o|
          20.cardinal.should eql 'twenty'
        end
        @inflectors[:ordinalizers].each do |o|
          20.ordinal.should eql 'twentieth'
        end
      end
    end

  end

  describe "Lexicalizable" do

    describe "#synonyms" do

      it "returns the synonyms of the word" do
        # Should the word be included in synonyms?
        'glass'.synonyms[-1].should eql 'looking_glass'
      end

    end

    describe "#antonyms" do
      it "returns the antonyms of the word" do
        'glass'.antonyms.should eql []
      end
    end

    describe "#hypernyms" do
      it "returns the hypernyms of the word" do
        'glass'.hypernyms[-1].should eql 'glasswork'
      end
    end

    describe "#hyponyms" do
      it "returns the hyponyms of the word" do
        'glass'.hyponyms[-1].should eql 'wineglass'
      end
    end

  end

  describe "Extractable" do
    describe "#tf_idf" do
      it "returns the TF*IDF score of the word" do
        #c = Treat::Entities::Collection.build(
        #Treat.paths.spec + 'samples/mathematicians')
        #c.do(:chunk, :segment, :tokenize)
        #c.words[30].tf_idf.should eql 0.2231
      end
    end
  end

end
