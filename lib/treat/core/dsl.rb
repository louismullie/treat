module Treat::Core::DSL
  
  # Message for deprecation of old DSL syntax.
  DeprecationMessage = "The DSL that used " +
  "capitalized entity names is now deprecated. " +
  "Use `include Treat::Core::DSL` along with " +
  "lowercase names from now on." 
  
  # Include DSL on base.
  def self.included(base)
    self.sweeten_entities(base)
    self.sweeten_learning(base)
  end

  # Map all classes in Treat::Entities to
  # a global builder function (Entity, etc.)
  def self.sweeten_entities(base, on = true)
    Treat.core.entities.list.each do |type|
      kname = type.cc.intern
      mname = type.intern
      klass = Treat::Entities.const_get(kname)
      Object.class_eval do
        define_method(mname.capitalize) do |*args|
          raise DeprecationMessage
        end
        define_method(mname) do |*args|
          klass.build(*args)
        end if on
        remove_method(mname) if !on
      end
    end
  end
  
  # Map all classes in the Learning module
  # to a global builder function (e.g. DataSet).
  def self.sweeten_learning(base, on = true)
    Treat::Learning.constants.each do |kname|
      mname = kname.downcase
      klass = Treat::Learning.const_get(kname)
      Object.class_eval do
        define_method(mname.capitalize) do |*args|
          raise DeprecationMessage
        end
        define_method(mname) do |*args| 
          klass.new(*args)
        end if on
        remove_method(mname) if !on
      end
    end
  end
  
end