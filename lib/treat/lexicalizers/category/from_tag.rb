# Finds the general part of speech of an entity
# (:sentence, :noun_phrase, :verb, :adverb, etc.)
# from its tag (e.g. 'S', 'NP', 'VBZ', 'ADV', etc.).
module Treat::Lexicalizers::Category::FromTag
  
  # A hash of phrase tags mapped to hashes of tag set => category
  Pttc = Treat::Languages::Tags::PhraseTagToCategory
  
  # A hash of word tags mapped to hashes of tag set => category.
  Wttc = Treat::Languages::Tags::WordTagToCategory
  
  # Find the category of the entity from its tag.
  def self.category(entity, options = {})
    
    tag = entity.check_has(:tag)
    
    return :unknown if tag.nil? || tag == ''
    return :sentence if tag == 'S'
    
    if entity.is_a?(Treat::Entities::Phrase)
      cat = Pttc[tag]
      unless cat
        cat = Wttc[tag]
      end
    elsif entity.is_a?(Treat::Entities::Word)
      cat = Wttc[tag]
    end
    
    return :unknown if cat == nil
    return cat[entity.tag_set] if cat.size == 1
    
    if entity.has?(:tag_set)
      if cat[entity.tag_set]
        return cat[entity.tag_set]
      else
        raise Treat::Exception,
        "The specified tag set (#{entity.tag_set})" +
        " does not contain the tag #{tag}."
      end
    else
      raise Treat::Exception,
      "No information can be found regarding "+
      "which tag set to use."
    end
    
  end
  
end
