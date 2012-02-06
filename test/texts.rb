module Treat
  module Tests

    module English
      Collection = Treat::Entities::Collection "#{Treat.test}/texts/english"
      LongDoc = Treat::Entities::Document "#{Treat.test}/texts/english/long.txt"
      MediumDoc = Treat::Entities::Document "#{Treat.test}/texts/english/medium.txt"
      ShortDoc = Treat::Entities::Document "#{Treat.test}/texts/english/short.txt"
      Time = Treat::Entities::Phrase 'every Tuesday at 3:00'
      Date = Treat::Entities::Phrase '2011/02/01'
      Sentence = Treat::Entities::Sentence 'The quick brown fox jumped over the lazy dog.'
      Verb = Treat::Entities::Word 'run'
      Word = Treat::Entities::Word 'running'
      Noun = Treat::Entities::Word 'captain'
      Number = Treat::Entities::Number 20
    end
    
  end
end
