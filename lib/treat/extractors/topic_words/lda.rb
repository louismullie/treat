module Treat
  module Extractors
    module TopicWords
      # An adapter for the 'lda-ruby' gem, which clusters
      # documents into topics based on Latent Dirichlet
      # Allocation.
      #
      # Original paper:
      # Blei, David M., Ng, Andrew Y., and Jordan, Michael
      # I. 2003. Latent dirichlet allocation. Journal of
      # Machine Learning Research. 3 (Mar. 2003), 993-1022.
      #
      # Project website: https://github.com/ealdent/lda-ruby
      class LDA
        # Require the lda-ruby gem.
        silence_warnings { require 'lda-ruby' }
        # Monkey patch the TextCorpus class to call it without
        # having to create any files.
        Lda::TextCorpus.class_eval do
          # Ruby, Y U NO SHUT UP!
          silence_warnings { undef :initialize }
          # Redefine initialize to take in an array of sections
          def initialize(sections)
            super(nil)
            sections.each do |section|
              add_document(Lda::TextDocument.new(self, section))
            end
          end
        end
        # Default options for the LDA algorithm.
        DefaultOptions = {
          :num_topics => 20,
          :words_per_topic => 10,
          :iterations => 20
        }
        # Retrieve the topic words of a collection.
        def self.topic_words(collection, options = {})
          options = DefaultOptions.merge(options)
          # Create a corpus with the collection
          sections = collection.sections.collect do |t|
            t.to_s.encode('UTF-8', :invalid => :replace,
            :undef => :replace, :replace => "?")            # Fix
          end
          corpus = Lda::TextCorpus.new(sections)

          # Create an Lda object for training
          lda = Lda::Lda.new(corpus)
          lda.num_topics = options[:num_topics]
          lda.max_iter = options[:iterations]
          # Run the EM algorithm using random starting points
          silence_stdout { lda.em('random') }
          # Load the vocabulary.
          if options[:vocabulary]
            lda.load_vocabulary(options[:vocabulary])
          end

          # Get the topic words.
          lda.top_words(options[:words_per_topic])
        end
      end
    end
  end
end
