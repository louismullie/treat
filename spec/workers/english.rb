require 'rspec'

require_relative '../../lib/treat'

class Treat::Specs::Workers::English

  @@workers = Treat.languages.english.workers
  Treat.core.language.default = 'english'

  describe Treat::Workers::Processors::Segmenters do

    before do
      @zones = ["Qala is first referred to in a fifteenth century portolan preserved at the Vatican library has taken its name from the qala or port of Mondoq ir-Rummien. It is the easternmost village of Gozo and has been inhabited since early times. The development of the present settlement began in the second half of the seventeenth century. It is a pleasant and rural place with many natural and historic attractions.",
      "Originally Radio Lehen il-Qala transmitted on frequency 106.5FM. But when consequently a national radio started transmissions on a frequency quite close, it caused a hindrance to our community radio." "People were complaining that the voice of the local radio was no longer clear and they were experiencing difficulty in following the programmes. This was a further proof of the value of the radio. It was a confirmation that it was a good and modern means of bringing the Christian message to the whole community. An official request was therefore made to the Broadcasting Authority and Radio Lehen il-Qala was given a new frequency - 106.3FM."]
      @groups = [
        ["Qala is first referred to in a fifteenth century portolan preserved at the Vatican library has taken its name from the qala or port of Mondoq ir-Rummien.", "It is the easternmost village of Gozo and has been inhabited since early times.", "The development of the present settlement began in the second half of the seventeenth century.", "It is a pleasant and rural place with many natural and historic attractions."],
        ["Originally Radio Lehen il-Qala transmitted on frequency 106.5FM.", "But when consequently a national radio started transmissions on a frequency quite close, it caused a hindrance to our community radio.", "People were complaining that the voice of the local radio was no longer clear and they were experiencing difficulty in following the programmes.", "This was a further proof of the value of the radio.", "It was a confirmation that it was a good and modern means of bringing the Christian message to the whole community.", "An official request was therefore made to the Broadcasting Authority and Radio Lehen il-Qala was given a new frequency - 106.3FM."]
      ]
    end

    context "when #segment is called on a zone" do
      it "segments the zone into groups" do
        @@workers.processors.segmenters.each do |segmenter|
          @zones.map { |zone| zone.segment(segmenter) }
          .map { |zone| zone.groups.map(&:to_s) }
          .should eql @groups
        end
      end
    end
  end

  describe Treat::Workers::Processors::Tokenizers do

    before do
      @groups = [
        "Julius Obsequens was a Roman writer who is believed to have lived in the middle of the fourth century AD.",
        "The only work associated with his name is the Liber de prodigiis (Book of Prodigies), completely extracted from an epitome, or abridgment, written by Livy; De prodigiis was constructed as an account of the wonders and portents that occurred in Rome between 249 BC-12 BC.",
        "Of great importance was the edition by the Basle Humanist Conrad Lycosthenes (1552), trying to reconstruct lost parts and illustrating the text with wood-cuts.",
        "These have been interpreted as reports of unidentified flying objects (UFOs), but may just as well describe meteors, and, since Obsequens, probably, writes in the 4th century, that is, some 400 years after the events he describes, they hardly qualify as eye-witness accounts.",
        '"At Aenariae, while Livius Troso was promulgating the laws at the beginning of the Italian war, at sunrise, there came a terrific noise in the sky, and a globe of fire appeared burning in the north.'
      ]
      @tokens = [
        ["Julius", "Obsequens", "was", "a", "Roman", "writer", "who", "is", "believed",
        "to", "have", "lived", "in", "the", "middle", "of", "the", "fourth", "century", "AD", "."],
        ["The", "only", "work", "associated", "with", "his", "name", "is", "the", "Liber",
          "de", "prodigiis", "(", "Book", "of", "Prodigies", ")", ",", "completely", "extracted",
          "from", "an", "epitome", ",", "or", "abridgment", ",", "written", "by", "Livy", ";",
          "De", "prodigiis", "was", "constructed", "as", "an", "account", "of", "the", "wonders",
        "and", "portents", "that", "occurred", "in", "Rome", "between", "249", "BC-12", "BC", "."],
        ["Of", "great", "importance", "was", "the", "edition", "by", "the", "Basle", "Humanist",
          "Conrad", "Lycosthenes", "(", "1552", ")", ",", "trying", "to", "reconstruct", "lost",
        "parts", "and", "illustrating", "the", "text", "with", "wood-cuts", "."],
        ["These", "have", "been", "interpreted", "as", "reports", "of", "unidentified", "flying",
          "objects", "(", "UFOs", ")", ",", "but", "may", "just", "as", "well", "describe", "meteors",
          ",", "and", ",", "since", "Obsequens", ",", "probably", ",", "writes", "in", "the", "4th",
          "century", ",", "that", "is", ",", "some", "400", "years", "after", "the", "events", "he",
        "describes", ",", "they", "hardly", "qualify", "as", "eye-witness", "accounts", "."],
        ["\"", "At", "Aenariae", ",", "while", "Livius", "Troso", "was", "promulgating", "the",
          "laws", "at", "the", "beginning", "of", "the", "Italian", "war", ",", "at", "sunrise",
          ",", "there", "came", "a", "terrific", "noise", "in", "the", "sky", ",", "and", "a",
        "globe", "of", "fire", "appeared", "burning", "in", "the", "north", "."]
      ]
    end
    context "when #tokenize is called on a group" do
      it "separates the group into tokens" do
        @@workers.processors.tokenizers.each do |tokenizer|
          @groups.dup.map { |text| group(text).tokenize(tokenizer) }
          .map { |group| group.tokens.map(&:to_s) }
          .should eql @tokens
        end
      end
    end
  end

  describe Treat::Workers::Processors::Parsers do
    before do
      @groups = ["A sentence to tokenize."]
      @phrases = [["A sentence", "to tokenize", "tokenize"]]
    end
    context "when #parse is called on a group" do
      it "tokenizes and parses the group into its syntactical phrases" do
        @@workers.processors.parsers.each do |parser|
          @groups.dup.map { |text| group(text).tokenize.parse(parser) }
          .map { |group| group.phrases.map(&:to_s)}
          .should eql @phrases
        end
      end
    end
  end

  describe Treat::Workers::Lexicalizers::Taggers do
    before do
      @groups = ["I was running"]
      @group_tags = [["PRP", "VBD", "VBG"]]
      @tokens = ["running", "man", "2", ".", "$"]
      @token_tags = ["VBG", "NN", "CD", ".", "$"]
    end
    context "when #tag is is called on a tokenized group" do
      it "annotates each token in the group with its tag and returns the tag 'G'" do
        @@workers.lexicalizers.taggers.each do |tagger|
          @groups.map { |txt| group(txt).tag(tagger) }
          .all? { |tag| tag == 'G' }.should be_true
          @groups.map { |txt| group(txt).tokenize }
          .map { |g| g.tokens.map(&:tag) }
          .should eql @group_tags
        end
      end
    end
    context "when #tag is called on a token" do
      it "annotates the token with its tag and returns it" do
        @@workers.lexicalizers.taggers.each do |tagger|
          @tokens.map { |tok| token(tok).tag(tagger)  }
          .should eql @token_tags
        end
      end
    end
  end

  describe Treat::Workers::Lexicalizers::Sensers do
    before do
      @words = ["throw", "weak", "table", "furniture"]
      @hyponyms = [
        ["slam", "flap down", "ground", "prostrate", "hurl", "hurtle",
          "cast", "heave", "pelt", "bombard", "defenestrate", "deliver",
          "pitch", "shy", "drive", "deep-six", "throw overboard", "ridge",
          "jettison", "fling", "lob", "chuck", "toss", "skim", "skip",
          "skitter", "juggle", "flip", "flick", "pass", "shed", "molt",
          "exuviate", "moult", "slough", "abscise", "exfoliate", "autotomize",
          "autotomise", "pop", "switch on", "turn on", "switch off", "cut",
          "turn off", "turn out", "shoot", "demoralize", "perplex", "vex",
          "stick", "get", "puzzle", "mystify", "baffle", "beat", "pose",
        "bewilder", "disorient", "disorientate"],
        [],
        ["correlation table", "contents", "table of contents", "actuarial table",
          "statistical table", "calendar", "file allocation table", "periodic table",
          "altar", "communion table", "Lord's table", "booth", "breakfast table",
          "card table", "coffee table", "cocktail table", "conference table",
          "council table", "council board", "console table", "console", "counter",
          "desk", "dressing table", "dresser", "vanity", "toilet table", "drop-leaf table",
          "gaming table", "gueridon", "kitchen table", "operating table", "Parsons table",
          "pedestal table", "pier table", "platen", "pool table", "billiard table",
          "snooker table", "stand", "table-tennis table", "ping-pong table",
          "pingpong table", "tea table", "trestle table", "worktable", "work table",
        "dining table", "board", "training table"],
        ["baby bed", "baby's bed", "bedroom furniture", "bedstead", "bedframe",
          "bookcase", "buffet", "counter", "sideboard", "cabinet", "chest of drawers",
          "chest", "bureau", "dresser", "dining-room furniture", "etagere", "fitment",
          "hallstand", "lamp", "lawn furniture", "nest", "office furniture", "seat",
          "sectional", "Sheraton", "sleeper", "table", "wall unit", "wardrobe",
        "closet", "press", "washstand", "wash-hand stand"]
      ]
      @hypernyms =  [
        ["propel", "impel", "move", "remove", "take", "take away", "withdraw",
          "put", "set", "place", "pose", "position", "lay", "communicate",
          "intercommunicate", "engage", "mesh", "lock", "operate", "send",
          "direct", "upset", "discompose", "untune", "disconcert", "discomfit",
          "express", "verbalize", "verbalise", "utter", "give tongue to", "shape",
        "form", "work", "mold", "mould", "forge", "dislodge", "bump", "turn", "release", "be"],
        [],
        ["array", "furniture", "piece of furniture", "article of furniture",
        "tableland", "plateau", "gathering", "assemblage", "fare"],
        ["furnishing"]
      ]
      @antonyms = [[], ["strong"], [], []]
      @synonyms = [
        ["throw", "shed", "cast", "cast off", "shake off", "throw off", "throw away",
          "drop", "thrust", "give", "flip", "switch", "project", "contrive", "bewilder",
          "bemuse", "discombobulate", "hurl", "hold", "have", "make", "confuse", "fox",
        "befuddle", "fuddle", "bedevil", "confound"],
        ["weak", "watery", "washy", "unaccented", "light", "fallible", "frail", "imperfect",
        "decrepit", "debile", "feeble", "infirm", "rickety", "sapless", "weakly", "faint"],
        ["table", "tabular array", "mesa", "board"],
        ["furniture", "piece of furniture", "article of furniture"]
      ]
    end

    context "when #synonym is called on a word, or #sense is "+
    "called on a word with option :nym set to 'hyponyms'" do
      it "returns the hyponyms of the word" do
        @@workers.lexicalizers.sensers.each do |senser|
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.hyponyms(senser) }.should eql @hyponyms
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.sense(nym: 'hyponyms') }
          .should eql @hyponyms
        end
      end
    end

    context "when #hypernyms is called on a word or #sense is "+
    "called on a word with option :nym set to 'hyponyms'" do
      it "returns the hyponyms of the word" do
        @@workers.lexicalizers.sensers.each do |senser|
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.hypernyms(senser) }.should eql @hypernyms
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.sense(senser, nym: 'hypernyms') }
          .should eql @hypernyms
        end
      end
    end

    context "when #antonyms is called on a word or #sense is" +
    "called on a word with option :nym set to 'antonyms'" do
      it "returns the hyponyms of the word" do
        @@workers.lexicalizers.sensers.each do |senser|
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.antonyms(senser) }.should eql @antonyms
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.sense(senser, nym: 'antonyms') }
          .should eql @antonyms
        end
      end
    end

    context "when #synonyms is called on a word or #sense is" +
    "called on a word with option :nym set to 'synonyms'" do
      it "returns the hyponyms of the word" do
        @@workers.lexicalizers.sensers.each do |senser|
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.synonyms(senser) }.should eql @synonyms
          @words.map { |txt| word(txt) }
          .map { |wrd| wrd.sense(senser, nym: 'synonyms') }
          .should eql @synonyms
        end
      end
    end

  end

  describe Treat::Workers::Lexicalizers::Categorizers do

    before do
      @phrase = "I was running"
      @fragment = "world. Hello"
      @sentence = "I am running."
      @group_categories = ["phrase",
      "fragment", "sentence"]
      @tokens = ["running"]
      @token_tags = ["verb"]
    end

    context "when #category is called on a tokenized and tagged group" do
      it "returns a tag corresponding to the group name" do
        @@workers.lexicalizers.categorizers.each do |categorizer|
          [phrase(@phrase), fragment(@fragment), sentence(@sentence)]
          .map { |grp| grp.apply(:tag).category(categorizer) }
          .should eql @group_categories
        end
      end
    end

    context "when #category is called called on a tagged token" do
      it "returns the category corresponding to the token's tag" do
        @@workers.lexicalizers.categorizers.each do |categorizer|
          @tokens.map { |tok| token(tok).apply(:tag).category(categorizer) }
          .should eql @token_tags
        end
      end
    end

  end

  describe Treat::Workers::Inflectors::Ordinalizers,
  Treat::Workers::Inflectors::Cardinalizers do

    before do
      @numbers = [1, 2, 3]
      @ordinal = ["first", "second", "third"]
      @cardinal = ["one", "two", "three"]
    end

    context "when #ordinal is called on a number" do
      it "returns the ordinal form (e.g. 'first') of the number" do
        @@workers.inflectors.ordinalizers.each do |ordinalizer|
          @numbers.map { |num| number(num) }
          .map { |num| num.ordinal(ordinalizer) }.should eql @ordinal
        end
      end
    end

    context "when #cardinal is called on a number" do
      it "returns the cardinal form (e.g. 'second' of the number)" do
        @@workers.inflectors.cardinalizers.each do |cardinalizer|
          @numbers.map { |num| number(num) }
          .map { |num| num.cardinal(cardinalizer) }.should eql @cardinal
        end
      end
    end

  end

  describe Treat::Workers::Inflectors::Stemmers do
    before do
      @words = ["running"]
      @stems = ["run"]
    end
    context "when #stem is called on a word" do
      it "annotates the word with its stem and returns the stem" do
        @@workers.inflectors.stemmers.each do |stemmer|
          @words.map { |wrd| wrd.stem(stemmer) }.should eql @stems
        end
      end
    end
  end

  describe Treat::Workers::Extractors::NameTag do
    before do
      @groups = ["Obama and Sarkozy will meet in Berlin."]
      @tags = [["person", nil, "person", nil, nil, nil, "location", nil]]
    end

    context "when #name_tag called on a tokenized group" do
      it "tags each token with its name tag" do
        @@workers.extractors.name_tag.each do |tagger|
          @groups.map { |grp| grp.tokenize.apply(:name_tag) }
          .map { |grp| grp.tokens.map { |t| t.get(:name_tag) } }
          .should eql @tags
        end
      end
    end

  end

  describe Treat::Workers::Extractors::Topics do
    before do
      @files = ["./spec/workers/examples/english/test.txt"]
      @topics = [['household goods and hardware',
      'united states of america', 'corporate/industrial']]
    end
    context "when #topics is called on a chunked, segmented and tokenized document" do
      it "annotates the document with its general topics and returns them" do
        @@workers.extractors.topics.each do |extractor|
          @files.map { |f| document(f).apply(:chunk, :segment, :tokenize) }
          .map { |doc| doc.topics }.should eql @topics
        end
      end
    end
  end

  describe Treat::Workers::Extractors::Time do
    before do
      @expressions = ["14 June 2012"]
      @days = [14]
      @months = [6]
      @years = [2012]
    end
    context "when called on a tokenized group representing a time expression" do
      it "returns the DateTime object corresponding to the time" do
        @@workers.extractors.time.each do |extractor|
          times = @expressions.map(&:time)
          times.all? { |t| t.is_a?(DateTime) }.should be_true
          times.map { |time| time.day }.should eql @days
          times.map { |time| time.month }.should eql @months
          times.map { |time| time.year }.should eql @years
        end
      end
    end
  end

  describe Treat::Workers::Inflectors::Conjugators do
    before do
      @infinitives = ["run"]
      @participles = ["running"]
    end

    context "when #present_participle is called on a word or #conjugate " +
    "is called on a word with option :form set to 'present_participle'" do
      it "returns the present participle form of the verb" do
        @@workers.inflectors.conjugators.each do |conjugator|
          @participles.map { |verb| verb
          .infinitive(conjugator) }
          .should eql @infinitives
          @participles.map { |verb| verb.conjugate(
          conjugator, form: 'infinitive') }
          .should eql @infinitives
        end
      end
    end

    context "when #infinitive is called on a word or #conjugate is " +
    "called on a word with option :form set to 'infinitive'" do
      it "returns the infinitive form of the verb" do
        @@workers.inflectors.conjugators.each do |conjugator|
          @infinitives.map { |verb| verb
          .present_participle(conjugator) }
          .should eql @participles
          @infinitives.map { |verb| verb.conjugate(
          conjugator, form: 'present_participle') }
          .should eql @participles
        end
      end
    end

  end

  describe Treat::Workers::Inflectors::Declensors do
    before do
      @singulars = ["man"]
      @plurals = ["men"]
    end
    context "when #plural is called on a word, or #declense "+
    "is called on a word with option :count set to 'plural'" do
      it "returns the plural form of the word" do
        @@workers.inflectors.declensors.each do |declensor|
          @singulars.map { |word| word.plural(declensor) }
          .should eql @plurals
          @singulars.map { |word| word
          .declense(declensor, count: 'plural') }
          .should eql @plurals
        end
      end
    end
    context "when #singular is called on a word, or #declense " +
    "is called on a word with option :count set to 'singular'" do
      it "returns the singular form of the word" do
        @@workers.inflectors.declensors.each do |declensor|
          next if declensor == :linguistics
          @plurals.map { |word| word.singular(declensor) }
          .should eql @singulars
          @singulars.map { |word| word
          .declense(declensor, count: 'singular') }
          .should eql @singulars
        end
      end
    end
  end

end
