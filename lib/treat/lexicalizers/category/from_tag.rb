# Finds the general part of speech of an entity
# (:sentence, :noun_phrase, :verb, :adverb, etc.)
# from its tag (e.g. 'S', 'NP', 'VBZ', 'ADV', etc.).
module Treat::Lexicalizers::Category::FromTag

  # A hash of phrase tags mapped to
  # hashes of tag set => category
  Pttc = Treat::Languages::
  Tags::PhraseTagToCategory

  # A hash of word tags mapped to
  # hashes of tag set => category.
  Wttc = Treat::Languages::
  Tags::WordTagToCategory

  # Find the category of the entity from its tag.
  def self.category(entity, options = {})

    tag = entity.check_has(:tag)

    return :unknown if tag.nil? || tag == ''
    return :sentence if tag == 'S'

    if entity.is_a?(
      Treat::Entities::Phrase)
      cat = Pttc[tag]
      unless cat
        cat = Wttc[tag]
      end
    else
      cat = Wttc[tag]
    end

    return :unknown if cat == nil
    
    ts = nil
    
    if entity.has?(:tag_set)
      ts = entity.get(:tag_set)
    elsif entity.parent_phrase && 
      entity.parent_phrase.has?(:tag_set)
      ts = entity.parent_phrase.get(:tag_set)
    else
      raise Treat::Exception,
      "No information can be found regarding "+
      "which tag set to use."
    end

    if cat[ts]
      return cat[ts]
    else
      raise Treat::Exception,
      "The specified tag set (#{ts})" +
      " does not contain the tag #{tag} " +
      "for token #{entity.to_s}."
    end

    :unknown

  end

end
