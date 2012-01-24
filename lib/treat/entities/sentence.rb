module Treat
  module Entities
    # Represents a sentence.
    class Sentence < Entity
      def subject(l = nil, o = {}); link(l, o.merge({:linkage => :subject})); end
    end
  end
end
