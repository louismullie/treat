module Treat::Config::Entities
  
  Options = {
    list:
    [:entity, :unknown, :email,
      :url, :symbol, :sentence,
      :punctuation, :number,
      :enclitic, :word, :token,
      :fragment, :phrase, :paragraph,
      :title, :zone, :list, :block,
      :page, :section, :collection,
    :document],
    order:
    [:token, :fragment, :phrase,
      :sentence, :zone, :section,
    :document, :collection],
  }
  
  # * Helper methods for syntactic sugar * #
  
  # Map all classes in Treat::Entities to
  # a global builder function (Entity, etc.)
  def self.sweeten_entities(on = true)
    Treat.core.entities.list.each do |type|
      next if type == :Symbol
      kname = type.cc.intern
      klass = Treat::Entities.const_get(kname)
      Object.class_eval do
        define_method(kname) do |val, opts={}|
          klass.build(val, opts)
        end if on
        remove_method(name) if !on
      end
    end
  end
  
  # Map all classes in the Learning module
  # to a global builder function (e.g. DataSet).
  def self.sweeten_learning(on = true)
    Treat::Learning.constants.each do |kname|
      Object.class_eval do
        define_method(kname) do |*args| 
          Treat::Learning.const_get(kname).new(*args)
        end if on
        remove_method(name) if !on
      end
    end
  end
  
end
