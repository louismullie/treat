# Uses a hand-made table to convert part-of-speech tags
# to descriptive English word or phrase categories.
# 
# Original paper: 1) Manning, Christopher and Schütze, Hinrich,
# 1999. Foundations of Statistical Natural Language
# Processing. MIT Press, p. 141-142. 
# 
# 2) Schiller et al. 1999. Guidelines fur das Tagging 
# deutscher Textcorpora. Universitat Tubingen. Institut
# fur maschinelle Sprachverarbeitung.
# 
# 3) Anne Abeille, Francois Toussenel, et Martine
# Cheradame. 2004. Corpus Le Monde: Annotations en 
# constituants. Guide pour les correcteurs. LLF et 
# UFRL and Universite Paris 7.

# 4) Xue and Palmer. 2008. Annotating the Propositions in 
# the Penn Chinese Treebank. University of Pennsylvania,
# Department of Computer Information and Science.
class Treat::Workers::Lexicalizers::Categorizers::FromTag

  Pttc = Treat.tags.aligned.phrase_tags_to_category
  Wttc = Treat.tags.aligned.word_tags_to_category
  Ptc = Treat.linguistics.punctuation.punct_to_category
  
  # Find the category of the entity from its tag.
  def self.category(entity, options = {})

    tag = entity.check_has(:tag)
    
    return 'unknown' if tag.nil? || tag == ''
    return 'fragment' if tag == 'F'
    return 'sentence' if tag == 'S'
    return 'number' if entity.type == :number
    
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

    'unknown'

  end

end
