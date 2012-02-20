# Obtain lexical information about a word using the
# ruby 'wordnet' gem.
class Treat::Lexicalizers::Synsets::Wordnet

  # Require the 'wordnet' gem.
  require 'wordnet'
  
  # Require an adaptor for Wordnet synsets.
  require 'treat/lexicalizers/synsets/wordnet/synset'
  
  # Noun, adjective and verb indexes.
  @@indexes = {}
  
  # Obtain lexical information about a word using the
  # ruby 'wordnet' gem.
  def self.synsets(word, options = nil)
    
    category = word.check_has(:category)
    
    unless options[:nym]
      raise Treat::Exception, "You must supply " +
      "the :nym option (:synonym, :hypernym, etc.)"
    end
    
    options[:nym] = (options[:nym].to_s + 's').intern
    
    unless [:noun, :adjective, :verb].
      include?(word.category)
      return []
    end
    
    cat = category.to_s.capitalize

    @@indexes[cat] ||= 
    ::WordNet.const_get(cat + 'Index').instance
    lemma = @@indexes[cat].find(word.value.downcase)

    return [] if lemma.nil?
    synsets = []
    
    lemma.synsets.each do |synset|
      synsets << 
      Treat::Lexicalizers::
      Synsets::Wordnet::
      Synset.new(synset)
    end
    
    nyms = (synsets.collect do |ss|
      ss.send(options[:nym])
    end - [word.value]).flatten
    word.set options[:nym], nyms
    synsets
    
  end

end