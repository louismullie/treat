# The C extension uses char* strings, and so Unicode strings 
# will give incorrect distances. Need to provide a pure 
# implementation if that's the case (FIX).
class Treat::Workers::Extractors::Distance::Levenshtein
  
  require 'levenshtein'
  
  DefaultOptions = {
    ins_cost: 1,
    del_cost: 1,
    sub_cost: 1
  }
  
  @@matcher = nil
  
  # Return the levensthein distance between
  # two strings taking into account the costs
  # of insertion, deletion, and substitution.
  def self.distance(entity, options)

    options = DefaultOptions.merge(options)

    unless options[:to]
      raise Treat::Exception, "Must supply " +
      "a string/entity to compare to using " +
      "the option :to for this worker."
    end
    
    a, b = entity.to_s, options[:to].to_s

    Levenshtein.distance(a, b)
  
  end
  
end
