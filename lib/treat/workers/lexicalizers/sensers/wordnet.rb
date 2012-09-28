# Sense information (synonyms, antonyms, hypernyms
# and hyponyms) obtained through a Ruby parser that
# accesses Wordnet flat files.
# 
# Original paper: George A. Miller (1995). WordNet: 
# A Lexical Database for English. Communications of 
# the ACM Vol. 38, No. 11: 39-41.
class Treat::Workers::Lexicalizers::Sensers::Wordnet

  # Require the 'wordnet' gem (install as 'rwordnet').
  require 'wordnet'
  
  # Patch for bug.
  ::WordNet.module_eval do
    remove_const(:SynsetType)
    const_set(:SynsetType, 
    {"n" => "noun", "v" => "verb", "a" => "adj"})
  end
  
  # Require an adaptor for Wordnet synsets.
  require_relative 'wordnet/synset'
  
  # Noun, adjective and verb indexes.
  @@indexes = {}
  
  # Obtain lexical information about a word using the
  # ruby 'wordnet' gem.
  def self.sense(word, options = nil)
    
    category = word.check_has(:category)
    
    unless options[:nym]
      raise Treat::Exception, "You must supply " +
      "the :nym option (:synonym, :hypernym, etc.)"
    end
    
    unless ['noun', 'adjective', 'verb'].
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
      Treat::Workers::Lexicalizers::Sensers::Wordnet::Synset.new(synset)
    end
    
    ((synsets.collect do |ss|
      ss.send(options[:nym])
    end - [word.value]).flatten).uniq
    
  end

end