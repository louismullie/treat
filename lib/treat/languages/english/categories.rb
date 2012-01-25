module Treat
  module Languages
    class English
      # A list of all possible word categories.
      Categories = [
        :adjective, :adverb, :noun, :verb, :interjection,
        :clitic, :coverb, :conjunction, :determiner, :particle,
        :preposition, :pronoun, :number, :symbol, :punctuation,
        :complementizer
      ]
      wttc = {}
      Treat::Languages::English::AlignedWordTags.each_slice(2) do |desc, tags|
        category = desc.gsub(',', ' ,').split(' ')[0].downcase.intern
        wttc[tags[0]] ||= {}; wttc[tags[1]] ||= {} ;wttc[tags[2]] ||= {}
        wttc[tags[0]][:claws_5] = category
        wttc[tags[1]][:brown] = category
        wttc[tags[2]][:penn] = category
      end
      # A hash converting word tags to word categories.
      WordTagToCategory = wttc
    end
  end
end
