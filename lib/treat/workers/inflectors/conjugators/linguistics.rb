# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to conjugate verbs.
#
# Project website: http://deveiate.org/projects/Linguistics/
module Treat::Workers::Inflectors::Conjugators::Linguistics

  DefaultOptions = {
    :strict => false
  }
  
  Forms = {
    'present_participle' =>
    {:mode => 'participle', :tense => 'present'},
    'infinitive' => {:mode => 'infinitive'},
    'plural_verb' => {:count => 'plural'},
    'singular_verb' => {:count => 'singular'}
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
    return if cat != 'verb' && options[:strict]

    options = Forms[options[:form].to_s] if options[:form]

    code = Treat::Loaders::Linguistics.load(entity.language)
    obj = entity.to_s.send(code)
  
    if options[:mode] == 'infinitive'
      obj.infinitive
    elsif options[:mode] == 'participle' && options[:tense] == 'present'
      obj.present_participle
    elsif options[:count] == 'plural' && options.size == 1
      obj.plural_verb
    else
      raise Treat::Exception,
      'This combination of modes, tenses, persons ' +
      'and/or counts is not presently supported.'
    end
    
  end
  
end
