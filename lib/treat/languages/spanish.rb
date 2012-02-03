module Treat
  module Languages
    class Spanish
      Processors = {
        chunkers: [:txt],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end