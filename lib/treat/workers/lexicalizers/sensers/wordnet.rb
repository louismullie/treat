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
    remove_const(:SYNSET_TYPES)
    const_set(:SYNSET_TYPES,
    {"n" => "noun", "v" => "verb", "a" => "adj"})
  end

  # Require an adaptor for Wordnet synsets.
  require_relative 'wordnet/synset'

  # Obtain lexical information about a word using the
  # ruby 'wordnet' gem.
  def self.sense(word, options = nil)

    category = word.check_has(:category)

    if !options[:nym]
      raise Treat::Exception, "You must supply " +
      "the :nym option ('synonyms', 'hypernyms', etc.)"
    end

    if !options[:nym].is_a?(Symbol)
      options[:nym] = options[:nym].intern
    end

    if ![:synonyms, :antonyms,
      :hypernyms, :hyponyms].include?(options[:nym])
      raise Treat::Exception, "You must supply " +
      "a valid :nym option ('synonyms', 'hypernyms', etc.)"
    end

    unless ['noun', 'adjective', 'verb'].
      include?(word.category)
      return []
    end

    cat = abbreviate(category)

    lemma = ::WordNet::Lemma.find(word.value.downcase, cat)

    return [] if lemma.nil?
    synsets = []

    lemma.synsets.each do |synset|
      synsets <<
      Treat::Workers::Lexicalizers::Sensers::Wordnet::Synset.new(synset)
    end

    ((synsets.collect do |ss|
      ss.send(options[:nym])
    end - [word.value]).
    flatten).uniq.map do |token|
      token.gsub('_', ' ')
    end
  end

  def self.abbreviate category
    if category == 'adjective'
      :adj
    elsif category == 'adverb'
      :adv
    else
      category.to_sym
    end
  end

end
