# Obtain lexical information about a word using the
# ruby 'wordnet' gem.
class Treat::Lexicalizers::Synsets::Wordnet

  # Require the 'wordnet' gem.
  require 'wordnet'
  
  # Patch for bug.
  ::WordNet.module_eval do
    remove_const(:SynsetType)
    const_set(:SynsetType, 
    {"n" => "noun", "v" => "verb", "a" => "adj"})
  end
  
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
      Treat::Lexicalizers::Synsets::Wordnet::Synset.new(synset)
    end
    
    ((synsets.collect do |ss|
      ss.send(options[:nym])
    end - [word.value]).flatten).uniq
    
  end

end