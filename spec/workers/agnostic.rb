class Treat::Specs::Workers::Agnostic
  
  @@workers = Treat.languages.agnostic.workers

  describe Treat::Workers::Extractors::Language do
    before do
      @entities = ["Obama and Sarkozy will meet in Berlin."]
      @languages = ["english"]
    end
    context "when called on any textual entity" do
      it "returns the language of the entity" do
        # Treat.core.language.detect = true
        @@workers.extractors.language.each do |extractor|
          @entities.map(&:language).should eql @languages
        end
        # Treat.core.language.detect = false
      end
    end
  end

  describe Treat::Workers::Extractors::TopicWords do

    before do
      @collections = ["./spec/workers/examples/english/economist"]
      @topic_words = [["euro", "zone", "european", "mrs", "greece", "chancellor",
      "berlin", "practice", "german", "germans"], ["bank", "minister", "central",
      "bajnai", "mr", "hu", "orban", "commission", "hungarian", "government"],
      ["bank", "mr", "central", "bajnai", "prime", "government", "brussels",
      "responsibility", "national", "independence"], ["mr", "bank", "central",
      "policies", "prime", "minister", "today", "financial", "government", "funds"],
      ["euro", "merkel", "mr", "zone", "european", "greece", "german", "berlin",
      "sarkozy", "government"], ["mr", "bajnai", "today", "orban", "government",
      "forced", "independence", "part", "hand", "minister"], ["sarkozy", "mrs",
      "zone", "euro", "fiscal", "called", "greece", "merkel", "german", "financial"],
      ["mr", "called", "central", "policies", "financial", "bank", "european",
      "prime", "minister", "shift"], ["bajnai", "orban", "prime", "mr", "government",
      "independence", "forced", "commission", "-", "hvg"], ["euro", "sarkozy", "fiscal",
      "merkel", "mr", "chancellor", "european", "german", "agenda", "soap"], ["mr",
        "bank", "called", "central", "today", "prime", "government", "minister", "european",
      "crisis"], ["mr", "fiscal", "mrs", "sarkozy", "merkel", "euro", "summit", "tax",
      "leaders", "ecb"], ["called", "government", "financial", "policies", "part", "bank",
      "central", "press", "mr", "president"], ["sarkozy", "merkel", "euro", "mr", "summit",
      "mrs", "fiscal", "merkozy", "economic", "german"], ["mr", "prime", "minister",
      "policies", "government", "financial", "crisis", "bank", "called", "part"], ["mr",
        "bank", "government", "today", "called", "central", "minister", "prime", "issues",
      "president"], ["mr", "orban", "central", "government", "parliament", "hungarian",
      "minister", "hu", "personal", "bajnai"], ["government", "called", "central", "european",
      "today", "bank", "prime", "financial", "part", "deficit"], ["mr", "orban", "government",
      "hungarian", "bank", "hvg", "minister", "-", "fidesz", "hand"], ["mr", "bank", "european",
      "minister", "policies", "crisis", "government", "president", "called", "shift"]]
    end

    context "when #topic_words is called on a chunked, segmented and tokenized collection" do
      it "annotates the collection with the topic words and returns them" do
        @@workers.extractors.topic_words.each do |extractor|
          @collections.map(&method(:collection))
          .map { |col| col.apply(:chunk,:segment,:tokenize) }
          map { |col| col.topic_words }.should eql @topic_words
        end
      end
    end
  end

  describe Treat::Workers::Formatters::Serializers do
    before do
      @texts = ["A test entity"]
    end
    context "when #serialize is called on any textual entity" do
      it "serializes the entity to disk and returns a pointer to the location" do
        # m = Treat::Entities::Entity.build
        @texts.map(&:to_entity).map(&:serialize)
        .map(&method(:entity)).map(&:to_s).should eql @texts
      end
    end
  end

  describe Treat::Workers::Formatters::Unserializers do
    before do
      @texts = ["A te"]
    end
    context "when #unserialize is called with a selector on any textual entity" do
      it "unserializes the file and loads it in the entity" do
        
      end
    end
  end
end

=begin
visualize: {
  entity: {
    examples: {
      standoff: [
        ["I walked to the store.", "(S\n   (PRP I)   (VBD walked)   (TO to)   (DT the)   (NN store)   (. .))\n"]
      ],
      tree: [
        ["I walked to the store.", "+ Sentence (*)  --- \"I walked to the store.\"  ---  {}   --- [] \n|\n+--> Word (*)  --- \"I\"  ---  {}   --- [] \n+--> Word (*)  --- \"walked\"  ---  {}   --- [] \n+--> Word (*)  --- \"to\"  ---  {}   --- [] \n+--> Word (*)  --- \"the\"  ---  {}   --- [] \n+--> Word (*)  --- \"store\"  ---  {}   --- [] \n+--> Punctuation (*)  --- \".\"  ---  {}   --- [] "]
      ],
      dot: [
        ["I walked to the store.", "graph {\n* [label=\"Sentence\\n\\\"I walked to the store.\\\"\",color=\"\"]\n* [label=\"Word\\n\\\"I\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"walked\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"to\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"the\\\"\",color=\"\"]\n* -- *;\n* [label=\"Word\\n\\\"store\\\"\",color=\"\"]\n* -- *;\n* [label=\"Punctuation\\n\\\".\\\"\",color=\"\"]\n* -- *;\n}"]
      ]
    },
    preprocessor: lambda  { |entity| entity.tokenize },
    generator: lambda  { |result| result.gsub(/[0-9]+/, '*') }
  }
},


describe Treat::Workers::Formatters::Visualizers do
  before do
    @texts = ["I walked to the store."]
  end
  describe "when #visualize is called with the :dot worker" do
    
  end
  describe "when #visualize is called with the :tree worker" do
    
  end
  describe "when #visualize is called with the :dot worker" do
    
  end
end

=begin
class Treat::Specs::Workers::Agnostic < Treat::Specs::Workers::Language

  # TODO: :tf_idf, :keywords, :classifiers
  # :read,. :unserialize

  Scenarios = {

    classify: {
      entity: {
        examples: [
          ["Homer", 1, lambda { {training: Treat::Learning::DataSet.build('test.marshal')} }]
        ],
        preprocessor: lambda do |entity|
          ds = Treat::Learning::DataSet.new(
          Treat::Learning::Problem.new(
            Treat::Learning::Question.new(:is_person, :word, :false, :discrete), 
            Treat::Learning::Feature.new(:first_capital, 0, "->(e) {  (e.to_s[0] =~ /^[A-Z]$/) ? 1 : 0 }"), 
            Treat::Learning::Tag.new(:value, 0)
          ))
          w1, w2, w3, w4, w5 = 
          ["Alfred", "lucky", "Hobbit", "hello", "Alice"].
          map { |w| Treat::Entities::Word.new(w) }
          w1.set :is_person, 1
          w2.set :is_person, 0
          w3.set :is_person, 1
          w4.set :is_person, 0
          w5.set :is_person, 1
          ds << w1; ds << w2; ds << w3
          ds.serialize :marshal, file: 'test.marshal'
        end
      }
    },

=begin
    keywords: {
      document: {
        examples: [
          ["./spec/workers/examples/english/economist/saving_the_euro.odt",
            ["crisis", "government", "called", "financial", "funds", "treaty"]]
          ],
          preprocessor: lambda do |document|
            coll = Treat::Entities::Collection.build('./spec/workers/examples/english/economist/')
            coll << document
            coll.apply(:chunk, :segment, :tokenize, :keywords)
            document
          end
        },
        section: {
          examples: [
            ["A test phrase", ["A", "test", "phrase"]]
          ]
        },
        zone: {
          examples: [
            ["A test phrase", ["A", "test", "phrase"]]
          ]
        }
      },
=end
=begin  
    unserialize: {
      examples: [
        ["A test entity.", "A test entity."]
      ],
      generator: lambda { |selector| Treat::Entities::Entity.build(selector).to_s }
    },
=end
=begin
      # Index
      search: {
        collection: {
          examples: [
            ["./spec/workers/examples/english/economist/", 
              "Hungary's troubles", {query: 'Hungary'}]
          ],
          generator: lambda { |docs| docs[0].titles[0] },
          preprocessor: lambda { |coll| coll.apply(:index) }
      },
    },

    keywords: {
      document: {
        examples: [
          ["./spec/languages/english/economist/saving_the_euro.odt", 
            ["A", "test", "phrase"]]
        ],
        preprocessor: lambda { |doc| doc.parent = Collection('./spec/languages/english/economist/') }
      },
      section: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ]
      },
      zone: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ]
      }
    },

    topic_words: {
      collection: {
        examples: [
          ["./spec/workers/examples/english/economist", [["orban", "minister", "bajnai", "mr", "government", "president", "law", "brussels", "commission", "hu"], ["government", "minister", "fidesz", "mr", "hvg", "today", "hungarian", "bajnai", "national", "office"], ["mr", "today", "central", "minister", "crisis", "prime", "president", "bank", "european", "government"], ["sarkozy", "mr", "greece", "german", "summit", "france", "merkel", "opera", "growth", "euro"], ["central", "hand", "minister", "week", "bank", "forced", "hungarian", "parliament", "political", "hvg"], ["minister", "crisis", "central", "bank", "hand", "law", "forced", "bajnai", "parliament", "president"], ["mr", "bank", "european", "central", "government", "called", "today", "financial", "policies", "press"], ["mr", "crisis", "government", "central", "today", "funds", "president", "issues", "bank", "called"], ["mr", "crisis", "minister", "today", "european", "prime", "financial", "president", "issues", "treaty"], ["central", "minister", "mr", "bajnai", "orban", "bank", "parliament", "week", "fidesz", "washington"], ["mr", "central", "government", "crisis", "minister", "orban", "hand", "fidesz", "bajnai", "judicial"], ["mr", "sarkozy", "chancellor", "government", "european", "merkozy", "role", "mrs", "interest", "quickly"], ["mr", "orban", "government", "crisis", "hungarian", "independence", "prime", "today", "hand", "bajnai"], ["euro", "fiscal", "merkel", "mrs", "sarkozy", "mr", "european", "zone", "leaders", "chancellor"], ["mr", "bank", "crisis", "financial", "president", "funds", "government", "treaty", "central", "part"], ["mr", "central", "minister", "crisis", "prime", "european", "government", "bank", "treaty", "issues"], ["sarkozy", "fiscal", "merkel", "mrs", "growth", "zone", "german", "role", "paper", "quickly"], ["mr", "government", "orban", "bank", "bajnai", "hungarian", "prime", "-", "hu", "commission"], ["mr", "orban", "today", "bank", "minister", "national", "government", "-", "crisis", "forced"], ["role", "summit", "merkel", "euro", "zone", "german", "mr", "greece", "sarkozy", "step"]]]
        ]
      }
    }
  }

=end
