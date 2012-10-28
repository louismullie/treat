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
  
end
