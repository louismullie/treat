module Treat
  module Languages
    class Dependencies
      Required = {
        :arabic => [],
        :english => ['rbtagger', 'ruby-stemmer', 'nickel', 'wordnet'],
        :chinese => [],
        :french => [],
        :german => [],
        :italian => [],
        :xinhua => []
      }
      Optional = {
        :english => ['uea-stemmer', 'tokenizer', 'tactful_tokenizer', 'engtagger', 'chronic']
      }
    end
  end
end
