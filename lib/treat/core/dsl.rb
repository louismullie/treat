module Treat::Core::DSL
  
  # Map all classes in Treat::Entities to
  # a global builder function (entity, word,
  # phrase, punctuation, symbol, list, etc.)
  def self.included(base)
    def method_missing(sym,*args,&block)
      @@entities ||= Treat.core.entities.list
      @@learning ||= Treat.core.learning.list
      if @@entities.include?(sym)
        klass = Treat::Entities.const_get(sym.cc)
        return klass.build(*args)
      elsif @@learning.include?(sym)
        klass = Treat::Learning.const_get(sym.cc)
        return klass.new(*args)
      else
        super(sym,*args,&block)
        raise "Uncaught method ended up in Treat DSL."
      end
    end
  end
  
end