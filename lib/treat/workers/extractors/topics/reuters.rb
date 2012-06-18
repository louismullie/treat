# A Ruby text categorizer that was trained using 
# the Reuters news story corpus. 
#
# Copyright 2005 Mark Watson. All rights reserved.
# Rewrite for inclusion in Treat by Louis Mullie (2011).
#
# Original project website: 
# http://www.markwatson.com/opensource/
module Treat::Workers::Extractors::Topics::Reuters

  # Require the Nokogiri XML parser.
  require 'nokogiri'
  
  # Hashes to hold the topics.
  @@industry = {}
  @@region = {}
  @@topics = {}
  
  # Get the general topic of the text using
  # a Reuters-trained model.
  #
  # Options: none.
  def self.topics(text, options = {})
    stems = []
    @@reduce = 0
    unless text.words.size > 0
      raise Treat::Exception,
      "Annotator 'topics' requires " +
      "processor 'tokenize'."
    end
    text.words.collect! do |tok|
      stem = tok.stem.downcase
      val = tok.value.downcase
      stems << stem
      unless stem == val
        stems << val
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
    @@industry = read_xml(Treat.paths.models + 
    'reuters/industry.xml')
    @@region = read_xml(Treat.paths.models + 
    'reuters/region.xml')
    @@topics = read_xml(Treat.paths.models + 
    'reuters/topics.xml')
  end
  
  # Read an XML file and populate a
  # hash of topics.
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
  
  # Score the words by adding the scores
  # of each word occurence.
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
    count_hash = best_of_hash(count_hash)
    count_hash.keys
  end
  
  # Retrieve the words with the scores above
  # cutoff inside the hash of scored words.
  def self.best_of_hash(hash, cutoff = 0.0, scale = 1.0)
    ret = {}
    hash.keys.each do |key|
      if hash[key] > cutoff
        ret[key] = hash[key] * scale
        ret[key] = ret[key].round(2)
      end
    end
    ret
  end
  
end
