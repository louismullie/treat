# Similarity measure for short strings such as person names.
# C extension won't work for Unicode strings; need to set 
# extension to "pure" in that case (FIX).
class Treat::Workers::Extractors::Similarity::JaroWinkler
  
  require 'fuzzystringmatch'
  
  DefaultOptions = {
    threshold: 0.7,
    implementation: nil
  }
  
  @@matcher = nil
  
  def self.similarity(entity, options={})
    
    options = DefaultOptions.merge(options)
    
    unless options[:to]
      raise Treat::Exception, "Must supply " +
      "a string/entity to compare to using " +
      "the option :to for this worker."
    end
    
    unless @@matcher
      impl = options[:implementation]
      impl ||= defined?(JRUBY_VERSION) ? :pure : :native
      klass = FuzzyStringMatch::JaroWinkler
      @@matcher = klass.create(impl)
    end
    
    a, b = entity.to_s, options[:to].to_s
    
    @@matcher.getDistance(a, b)
        
  end

end
