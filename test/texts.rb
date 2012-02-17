module Treat::Tests

  class TestLanguage

    def self.extended(base)
      
      base.const_set :Collection, Treat::Entities::Collection texts
      base.const_set :LongDocument, Treat::Entities::Document texts + 'long.txt'
      base.const_set :MediumDocument, Treat::Entities::Document texts + 'medium.txt'
      base.const_set :ShortDocument, Treat::Entities::Document texts + 'short.txt'
      
    end

    Expectations = {
      Processors => {
        [:tokenize, Sentence,
          lambda do |entity|
            entity.word_count.must_equal(9) &&
            entity.punctuation_count.must_equal(1)
          end
        ],
        [:chunk, ShortDocument,
          lambda do |entity|
            entity.word_count.must_equal(9) &&
            entity.punctuation_count.must_equal(1)
          end
        ],
        [:parse, Sentence,
          lambda do |entity|
            entity.word_count.must_equal(9)
          end
        ],
      }
    }
    
    def self.texts
      Treat.lib + '../test/texts/' + cl(self.to_s).downcase
    end

  end

  class English < TestLanguage

    Section = "A short biography of Michel Foucault

    Michel Foucault, born Paul-Michel Foucault (15 October 1926 – 25 June 1984), was a French philosopher, social theorist and historian of ideas. He held a chair at the College de France with the title \"History of Systems of Thought,\" and lectured at the University at Buffalo and the University of California, Berkeley."

    Sentence = Treat::Entities::Sentence 'The quick brown fox jumped over the lazy dog.'
    
    Verb = Treat::Entities::Word 'run'
    
    Word = Treat::Entities::Word 'running'
    
    Noun = Treat::Entities::Word 'captain'
    
    Number = Treat::Entities::Number 20
    
    Time = Treat::Entities::Phrase 'every Tuesday at 3:00'
    
    Date = Treat::Entities::Phrase '2011/02/01'


  end

end