module Treat
  module Languages
    class Swedish
      Processors = {
        chunkers: [:txt],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end