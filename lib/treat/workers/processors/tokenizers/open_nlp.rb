# Maximum entropy tokenization supplied by OpenNLP.
class Treat::Workers::Processors::Tokenizers::OpenNlp

  require 'open-nlp'
  Treat::Loaders::OpenNLP.load
  
  @@tokenizers = {}
  
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
      entity << Treat::Entities::Token.from_string(token)
    end

  end

end
