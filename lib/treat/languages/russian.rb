module Treat
  module Languages
    class Russian
      Processors = {
        chunkers: [:txt],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end