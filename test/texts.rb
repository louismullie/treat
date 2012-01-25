module Treat
  module Tests

    EnglishHtmlDoc = Treat::Entities::Document("#{Treat.test}/texts/english/long.html")
    EnglishLongDoc = Treat::Entities::Document("#{Treat.test}/texts/english/long.txt")    
    EnglishMediumDoc = Treat::Entities::Document("#{Treat.test}/texts/english/medium.txt")  
    EnglishShortDoc = Treat::Entities::Document("#{Treat.test}/texts/english/short.txt")
      
    EnglishTime = Treat::Entities::Phrase('5 PM')
    EnglishDate = Treat::Entities::Phrase('this tuesday')
    
    EnglishSentence = Treat::Entities::Sentence('The quick brown fox jumped over the lazy dog.')
    
    EnglishVerb = Treat::Entities::Word('run'); EnglishVerb.set :category, :verb
    EnglishWord = Treat::Entities::Word('running')
    EnglishNoun = Treat::Entities::Word('captain')
    Number = Treat::Entities::Number(20)
    
  end
end
