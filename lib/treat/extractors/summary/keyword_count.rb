# Selects the N sentences that contain the number
# of keywords to create a summary for a document.
module Treat::Extractors::Summary::KeywordCount

  DefaultOptions = {
    :num_sentences => 10
  }
  
  def self.summary(document, options = {})

    document.check_has(:keywords, false)
    options = DefaultOptions.merge(options)
    
    summary = ''
    
    summary = "#{document.titles[0].to_s}\n\n"
    sentences = {}

    document.each_sentence do |sentence|
      if sentence.has?(:keyword_count)
        sentences[sentence.to_s] =
        sentence.keyword_count
      end
    end

    selected = select(sentences, 
    options[:num_sentences])
    summary += selected.join(' ')
    summary + "\n"

  end

  def self.select(hash, n)
    
    min = hash.values.sort[-n]
    a = []
    i = 0
    hash.each do |k, v|
      if i < n and v <= min
        (a.push(k) and i += 1)
      end
    end
    
    a
  end

end
