# Maximum entropy tokenization supplied by OpenNLP.
class Treat::Workers::Processors::Tokenizers::Maxent

  require 'open-nlp'
  OpenNLP.load
  
  # Maximum entropy tokenization.
  def self.tokenize(entity, options = {})
    
    lang = entity.language
    str = entity.to_s
    
    unless @@tokenizers[lang]
      OpenNLP.use(lang.intern)
      @@tokenizers[lang] = 
      OpenNLP::TokenizerME.new
    end
    
    tokenizer = @@tokenizers[lang]
    tokens = tokenizer.tokenize(str).to_a
    
    tokens.each do |token|
      entity << Treat::Entities
      ::Token.from_string(chunk)
    end

  end

end
