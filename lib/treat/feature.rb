module Treat
  # This class represents a probabilistic feature;
  # it is currently not used, because its
  # behaviour is non-deterministic. Perhaps at 
  # some point this will be of value for specific
  # algorithms and so I'm keeping it here.
  class Feature
    # Undefine all methods, except those that 
    # create any problems (e.g. with serializing).
    instance_methods.each do |meth|
      undef_method(meth) if meth !~ 
      /^(__|object_id|class|instance_variables|instance_variable_get)/
    end
    # Allows to read the probability hash,
    # the possible values of the feature,
    # and the best value (with highest P).
    attr_reader :p_hash, :values, :best
    # Initialize the feature with a hash 
    # of features => probabilities.
    def initialize(p_hash)
      @p_hash = p_hash
      normalize
      max = @p_hash.values.max
      @best = @p_hash.select { |i,j| j == max }.keys.sample
      @values = @p_hash.keys
      type = @values[0].class
      if type == ::Symbol || type == ::NilClass
        @object = @best
      else
        @object = type.new(@best)
      end
    end
    # Normalize the probabilities, so that
    # the sum of all probabilities is 1,
    # except if the sum of all probabilities
    # is already below one (in which case we
    # assume that the feature is intentionally
    # incomplete).
    def normalize
      sum = @p_hash.inject(0.0) { |r, e| r + e[1] }
      return if sum <= 1.0
      p = {}
      @p_hash.each { |k,v| p[k] =  v.to_f/sum.to_f }
      @p_hash = p
    end
    # Find the probability of value x.
    def probability(x)
      @p_hash[x] ? @p_hash[x] : 0
    end
    # Alias for probability: p(x).
    alias :p :probability
    # Catch all other methods than the ones
    # explicitly defined. 
    def method_missing(sym, *args, &block)
      @object.send(sym, *args, &block)
    end
  end
end