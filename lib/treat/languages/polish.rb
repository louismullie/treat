module Treat
  module Languages
    class Polish
      Processors = {
        chunkers: [:txt],
        segmenters: [:punkt],
        tokenizers: [:tactful]
      }
    end
  end
end