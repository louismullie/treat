module Treat
  module Languages
    class Dutch
      Processors = {
        :chunkers => [:txt],
        :segmenters => [:punkt],
        :tokenizers => [:tactful]
      }
    end
  end
end
