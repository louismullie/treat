# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to conjugate verbs.
#
# Project website: http://deveiate.org/projects/Linguistics/
module Treat::Inflectors::Conjugators::Linguistics

  require 'treat/loaders/linguistics'
  
  DefaultOptions = {
    :strict => false
  }
  
  Forms = {
    :present_participle =>
    {:mode => :participle, :tense => :present},
    :infinitive => {:mode => :infinitive},
    :plural_verb => {:count => :plural},
    :singular_verb => {:count => :singular}
  }
  
  # Conjugate a verb using ruby linguistics with the specified
  # mode, tense, count and person.
  #
  # Options:
  #
  # - (Boolean) :strict => whether to tag all words or only verbs.
  # - (Symbol) :mode => :infinitive, :indicative, :subjunctive, :participle
  # - (Symbol) :tense => :past, :present, :future
  # - (Symbol) :count => :singular, :plural
  # - (Symbol) :person => :first, :second, :third
  # 
  def self.conjugate(entity, options = {})
    
    options = DefaultOptions.merge(options)
    cat = entity.check_has(:category)
    return if cat != :verb && options[:strict]
    
    options = Forms[options[:form]] if options[:form]
    
    klass = Treat::Loaders::Linguistics.load(entity.language)
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
