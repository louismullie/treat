module Treat
  module Resources
    class Categories
      List = [
        :adjective, :adverb, :noun, :verb, :interjection,
        :clitic, :coverb, :conjunction, :determiner, :particle,
        :preposition, :pronoun, :number, :symbol, :punctuation,     
        :complementizer
      ]
      wttc = {}
      Treat::Resources::Tags::AlignedWordTags.each_slice(2) do |desc, tags|
        desc = desc.gsub(',', ' ,').split(' ')[0].downcase
        tags.each { |tag| wttc[tag] = desc.intern }
      end
      WordTagToCategory = wttc
    end
  end
end
