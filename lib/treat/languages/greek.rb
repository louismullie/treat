module Treat
  module Languages
    class Greek
      Processors = {
        chunkers: [:txt],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end