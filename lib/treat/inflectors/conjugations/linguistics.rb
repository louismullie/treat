# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to conjugate verbs.
#
# Project website: http://deveiate.org/projects/Linguistics/
module Treat::Inflectors::Conjugations::Linguistics

  require 'treat/loaders/linguistics'
  
  # Conjugate a verb using ruby linguistics with the specified
  # mode, tense, count and person.
  #
  # Options:
  #
  # - (Symbol) :mode => :infinitive, :indicative, :subjunctive, :participle
  # - (Symbol) :tense => :past, :present, :future
  # - (Symbol) :count => :singular, :plural
  # - (Symbol) :person => :first, :second, :third
  def self.conjugations(entity, options = {})
    
    return unless entity.category == :verb
    
    klass = Treat::Helpers::LinguisticsLoader.load(entity.language)
    if options[:mode] == :infinitive
      silence_warnings { klass.infinitive(entity.to_s) }
    elsif options[:mode] == :participle && options[:tense] == :present
      silence_warnings { klass.present_participle(entity.to_s) }
    elsif options[:count] == :plural && options.size == 1
      silence_warnings { klass.plural_verb(entity.to_s) }
    else
      raise Treat::Exception,
      'This combination of modes, tenses, persons ' +
      'and/or counts is not presently supported.'
    end
    
  end
  
end
