module Treat::Specs::Workers
    
    Descriptions = {
      stem: "returns the stem of the word",
      conjugate: {
        infinitive: "returns the infinitive form of a verb",
        present_participle: "returns the present participle form of a verb"
      },
      declense: {
        plural: "returns the plural form of the word",
        singular: "returns the singular form of the word"
      },
      ordinal: "returns the ordinal form of a number",
      sense: {
        synonyms: "returns the synonyms of the word",
        antonyms: "returns the antonyms of the word",
        hypernyms: "returns the hypernyms of the word",
        hyponyms:"returns the hyponyms of the word"
      },
      tag: "returns the tag of the token",
      category: "returns the category of the number, punctuation or symbol",
      name_tag: "tags the named entity words in the group of words",
      time: "annotates all entities within the group with time information",
      tokenize: "splits the group of words into tokens and adds them as children of the group",
      parse: "parses a group of words into its syntax tree, adding nested phrases and tokens as children of the group",
      topics: "returns a list of general topics the document belongs to",
      segment: "splits a zone into phrases/sentences and adds them as children of the zone"
    }

end