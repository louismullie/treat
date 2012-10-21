# Helper methods to detect misspellings
# and suggest alternatives to the user.
class Treat::Helpers::Help
  
  # Search the list to see if there are
  # words similar to #name in the #list
  # If yes, return a string saying
  # "Did you mean ... ?" with the names.
  def self.did_you_mean?(list, name)
    return '' # Fix
    list = list.map { |e| e.to_s }
    name = name.to_s
    sugg = []
    list.each do |element|
      l = self.levenshtein(element,name)
      if  l > 0 && l < 2
        sugg << element
      end
    end
    unless sugg.size == 0
      if sugg.size == 1
        msg += " Perhaps you meant '#{sugg[0]}' ?"
      else
        sugg_quote = sugg[0..-2].map do
          |x| '\'' + x + '\''
        end
        msg += " Perhaps you meant " +
        "#{sugg_quote.join(', ')}," +
        " or '#{sugg[-1]}' ?"
      end
    end
    msg
  end
  
  # Return the levensthein distance between
  # two strings taking into account the costs
  # of insertion, deletion, and substitution.
  # Used by did_you_mean? to detect typos.
  def self.levenshtein(first, other, ins=1, del=1, sub=1)
    return nil if first.nil? || other.nil?
    dm = []
    dm[0] = (0..first.length).collect { |i| i * ins}
    fill = [0] * (first.length - 1).abs
    for i in 1..other.length
      dm[i] = [i * del, fill.flatten]
    end
    for i in 1..other.length
      for j in 1..first.length
        dm[i][j] = [
          dm[i-1][j-1] +
          (first[i-1] ==
          other[i-1] ? 0 : sub),
          dm[i][j-1] + ins,
          dm[i-1][j] + del
        ].min
      end
    end
    dm[other.length][first.length]
  end

end
