# Handles all configuration related 
# to understanding of part of speech
# and phrasal tags.
class Treat::Config::Tags
  
  # Generate a map of word and phrase tags 
  # to their syntactic category, keyed by 
  # tag set.
  def self.configure!
    super
    config = self.config[:aligned].dup
    word_tags, phrase_tags, tag_sets = 
    config[:word_tags], config[:phrase_tags]
    tag_sets = config[:tag_sets]
    config[:word_tags_to_category] = 
    align_tags(word_tags, tag_sets)
    config[:phrase_tags_to_category] =
    align_tags(phrase_tags, tag_sets)
    self.config[:aligned] = config
 end
 
 # Helper methods for tag set config.
 # Align tag tags in the tag set 
 def self.align_tags(tags, tag_sets)
   wttc = {}
   tags.each_slice(2) do |desc, tags|
     category = desc.gsub(',', ' ,').
     split(' ')[0].downcase
     tag_sets.each_with_index do |tag_set, i|
       next unless tags[i]
       wttc[tags[i]] ||= {}
       wttc[tags[i]][tag_set] = category
     end
   end; return wttc
 end
   
end