module Treat::Extractors::Summary::DecisionTree

  DefaultOptions = {
    
    :generator => lambda do |sentence|
      self.get_data_items(sentence)
    end,
    
    :training_set => nil,
    
    :question => :is_key_sentence?
    
  }

  def self.summary(document, options = {})

    options = DefaultOptions.merge(options)

    summary = ''

    summary = "#{document.titles[0].to_s}\n\n"
    sentences = {}

    document.each_sentence do |sentence|
      if id3.eval(options[:generator].call(sentence))
        sentences << sentence
      end
    end

    summary += sentences.join(' ')
    summary + "\n"

  end

  def self.get_data_item(s)

    line = {}
    
    line << s.position_in_paragraph
    line << s.position_from_end_of_paragraph
    line << s.word_count
    line << s.number_count
    line << s.tag_of_first_word

    line << (s.has?(:keyword_count) ?
    s.keyword_count : 0)

    if s.has?(:named_entity_count)
      line << s.named_entity_count[:person]
      line << s.named_entity_count[:date]
      line << s.named_entity_count[:location]
    else
      3.times { line << 0 }
    end

    line << (s.has?(:coreference_count) ?
    s.coreference_count : 0)

    line << s.is_key_sentence?

    line

  end
end
