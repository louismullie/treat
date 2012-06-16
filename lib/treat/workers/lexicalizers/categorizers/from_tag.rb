# Finds the general part of speech of an entity
# (:sentence, :noun_phrase, :verb, :adverb, etc.)
# from its tag (e.g. 'S', 'NP', 'VBZ', 'ADV', etc.).
class Treat::Workers::Lexicalizers::Categorizers::FromTag

  Pttc = Treat::Universalisation::Tags::PhraseTagToCategory
  Wttc = Treat::Universalisation::Tags::WordTagToCategory
  Ptc = Treat.linguistics.punctuation.sign_to_category
  
  # Find the category of the entity from its tag.
  def self.category(entity, options = {})

    tag = entity.check_has(:tag)
    
    return :unknown if tag.nil? || tag == '' || entity.type == :symbol
    return :sentence if tag == 'S' || entity.type == :sentence
    return :number if entity.type == :number
    
    return Ptc[entity.to_s] if entity.type == :punctuation
    
    if entity.is_a?(Treat::Entities::Phrase)
      cat = Pttc[tag]
      cat = Wttc[tag] unless cat
    else
      cat = Wttc[tag]
    end

    return :unknown if cat == nil
    
    ts = nil
    
    if entity.has?(:tag_set)
      ts = entity.get(:tag_set)
    else
      a = entity.ancestor_with_feature(:tag_set)
      if a
        ts = a.get(:tag_set)
      else
        raise Treat::Exception,
        "No information can be found regarding "+
        "which tag set to use."
      end
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
