# Allows to retrieve the frequency of a token inside
# one of the ancestors of the token.
module Treat::Statistics::FrequencyIn
  
  # Find the frequency of the entity in the supplied
  # parent.
  # 
  # Options:
  #
  # - (Symbol) :parent, the parent entity in which
  # to count the number occurences of the word. By
  # default, this is the root node of the tree.
  def self.frequency_in(entity, options = {})
    options = DefaultOptions.merge(options)
    tr = entity.token_registry(options[:parent])
    tv = tr[:value][entity.value]
    tv ? tv.size : 1
  end
  
end