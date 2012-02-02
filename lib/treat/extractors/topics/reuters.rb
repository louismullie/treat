module Treat
  module Extractors
    module Topics
      # A Ruby Part text categorizer that was trained
      # using the Reuters news story corpus.  Version 0.1
      #
      # Copyright 2005 Mark Watson.  All rights reserved.
      # This software is released under the GPL.
      # Rewrite for inclusion in Treat by Louis Mullie (2011).
      # 
      # Original project website: http://www.markwatson.com/opensource/
      class Reuters
        # Require the Nokogiri XML parser.
        require 'nokogiri'
        # Hashes to hold the topics.
        @@industry = {}
        @@region = {}
        @@topics = {}
        # Get the topic of the text.
        # 
        # Options: none.
        def self.topics(text, options = {})
          stems = []
          @@reduce = 0
          unless text.words.size > 0
            raise Treat::Exception,
            "Annotator 'topics' requires processor 'tokenize'."
          end
          text.words.collect! do |tok|
            stem = tok.stem.downcase
            val = tok.value.downcase
            stems << stem
            unless stem == val
              stems << val
              @@reduce += 1
            end
          end
          get_topics
          score_words(@@industry, stems) + 
          score_words(@@region, stems) +
          score_words(@@topics, stems)
          #Treat::Feature.new(topics)
        end
        # Read the topics from the XML files.
        def self.get_topics
          return unless @@industry.size == 0
          @@industry = read_xml(Treat.lib + '/treat/extractors/topics/reuters/industry.xml')
          @@region = read_xml(Treat.lib + '/treat/extractors/topics/reuters/region.xml')
          @@topics = read_xml(Treat.lib + '/treat/extractors/topics/reuters/topics.xml')
        end
        def self.read_xml(file_name)
          hash = {}
          doc = Nokogiri::XML(File.read(file_name))
          doc.root.children.each do |category|
            cat = category["cat"]
            next if cat.nil?
            cat = cat.downcase
            hash[cat] ||= {}
            hash[cat][category["name"]] =
            category["score"].to_f
          end
          hash
        end
        def self.score_words(hash, word_list)
          category_names = hash.keys
          count_hash = {}
          category_names.each do |cat_name|
            cat_name = cat_name.downcase
            count_hash[cat_name] ||= 0
            word_list.each do |word|
              unless hash[cat_name][word].nil?
                count_hash[cat_name] += 
                hash[cat_name][word]
              end
            end
          end
          count_hash = best_of_hash(count_hash,
          (word_list.size.to_f - @@reduce.to_f)  / 250.0, 
          100.0 / (1 + word_list.size.to_f - @@reduce.to_f))
          count_hash.keys
        end
        def self.best_of_hash(hash, cutoff = 1, scale = 1)
          cutoff = 1 if cutoff == 0
          ret = {}
          hash.keys.each() do |key|
            if hash[key] > cutoff
              ret[key] = hash[key] * scale 
              ret[key] = ret[key].round(2)
            end
          end
          ret
        end
      end
    end
  end
end
