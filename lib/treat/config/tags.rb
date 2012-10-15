module Treat::Config::Tags
  
  # * Helper methods for tag set config * #

   # Generate a map of word and phrase tags 
   # to their syntactic category, by tag set. 
   def self.gen_tag_maps!(config)
     ts = config[:tag_sets]
     config[:word_tags_to_category] = 
     align_tags(config[:word_tags], ts)
     config[:phrase_tags_to_category] =
     align_tags(config[:phrase_tags], ts)
   end

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
   
   self.gen_tag_maps!(config[:tags][:aligned])
   
  Options = {
    aligned: {
      tag_sets: [
        :claws_c5, :brown, :penn,
        :stutgart, :chinese, :paris7
      ],
      phrase_tags: [
        'Adjectival phrase', ['', '', 'ADJP', '', '', 'AP'],
        'Adverbial phrase', ['', '', 'ADVP', '', '', 'AdP'],
        'Conjunction phrase', ['', '', 'CONJP', '', '', 'Ssub'],
        'Fragment', ['', '', 'FRAG', '', '', ''],
        'Interjectional phrase', ['', '', 'INTJ', '', '', ''],
        'List marker', ['', '', 'LST', '', '', ''],
        'Not a phrase', ['', '', 'NAC', '', '', ''],
        'Noun phrase', ['', '', 'NP', '', '', 'NP'],
        'Verbal nucleus',  ['', '', '', '', '', 'VN'],
        'Head of noun phrase', ['', '', 'NX', '', '', ''],
        'Prepositional phrase', ['', '', 'PP', '', '', 'PP'],
        'Parenthetical', ['', '', 'PRN', '', '', ''],
        'Particle', ['', '', 'PRT', '', '', ''],
        'Participial phrase', ['', '', '', '', '', 'VPart'],
        'Quantifier phrase', ['', '', 'QP', '', '', ''],
        'Relative clause', ['', '', 'RRC', '', '', 'Srel'],
        'Coordinated phrase', ['', '', 'UCP', '', '', 'COORD'],
        'Infinitival phrase', ['', '', '', '', '', 'VPinf'],
        'Verb phrase', ['', '', 'VP', '', '', ''],
        'Wh adjective phrase', ['', '', 'WHADJP', '', '', ''],
        'Wh adverb phrase', ['', '', 'WHAVP', '', '', ''],
        'Wh noun phrase', ['', '', 'WHNP', '', '', ''],
        'Wh prepositional phrase', ['', '', 'WHPP', '', '', ''],
        'Unknown', ['', '', 'X', '', '', ''],
        'Phrase', ['', '', 'P', '', '', 'Sint'],
        'Sentence', ['', '', 'S', '', '', 'SENT'],
        'Phrase', ['', '', 'SBAR', '', '', ''] # Fix
      ],
      word_tags: [

        # Aligned tags for the Claws C5, Brown and Penn tag sets.
        'Adjective', ['AJ0', 'JJ', 'JJ', '', 'JJ', 'A'],
        'Adjective', ['AJ0', 'JJ', 'JJ', '', 'JJ', 'ADJ'],
        'Ajective, adverbial or predicative', ['', '', '', 'ADJD', '', 'ADJ'],
        'Adjective, attribute', ['', '', '', 'ADJA', 'VA', 'ADJ'],
        'Adjective, ordinal number', ['ORD', 'OD', 'JJ', '', 'OD', 'ADJ'],
        'Adjective, comparative', ['AJC', 'JJR', 'JJR', 'KOKOM', '', 'ADJ'],
        'Adjective, superlative', ['AJS', 'JJT', 'JJS', '', 'JJ', 'ADJ'],
        'Adjective, superlative, semantically', ['AJ0', 'JJS', 'JJ', '', '', 'ADJ'],
        'Adjective, cardinal number', ['CRD', 'CD', 'CD', 'CARD', 'CD', 'ADJ'],
        'Adjective, cardinal number, one', ['PNI', 'CD', 'CD', 'CARD', 'CD', 'ADJ'],

        'Adverb', ['AV0', 'RB', 'RB', 'ADV', 'AD', 'ADV'],
        'Adverb, negative', ['XX0', '*', 'RB', 'PTKNEG', '', 'ADV'],
        'Adverb, comparative', ['AV0', 'RBR', 'RBR', '', 'AD', 'ADV'],
        'Adverb, superlative', ['AV0', 'RBT', 'RBS', '', 'AD', 'ADV'],
        'Adverb, particle', ['AVP', 'RP', 'RP', '', '', 'ADV'],
        'Adverb, question', ['AVQ', 'WRB', 'WRB', '', 'AD', 'ADV'],
        'Adverb, degree & question', ['AVQ', 'WQL', 'WRB', '', 'ADV'],
        'Adverb, degree', ['AV0', 'QL', 'RB', '', '', 'ADV'],
        'Adverb, degree, postposed', ['AV0', 'QLP', 'RB', '', '', 'ADV'],
        'Adverb, nominal', ['AV0', 'RN', 'RB', 'PROP', '', 'ADV'],
        'Adverb, pronominal', ['', '', '', '', 'PROP', '', 'ADV'],

        'Conjunction, coordination', ['CJC', 'CC', 'CC', 'KON', 'CC', 'COOD'],
        'Conjunction, coordination, and', ['CJC', 'CC', 'CC', 'KON', 'CC', 'ET'],
        'Conjunction, subordination', ['CJS', 'CS', 'IN', 'KOUS', 'CS', 'CONJ'],
        'Conjunction, subordination with to and infinitive', ['', '', '', 'KOUI', '', ''],
        'Conjunction, complementizer, that', ['CJT', 'CS', 'IN', '', '', 'C'],

        'Determiner', ['DT0', 'DT', 'DT', '', 'DT', 'D'],
        'Determiner, pronoun', ['DT0', 'DTI', 'DT', '', '', 'D'],
        'Determiner, pronoun, plural', ['DT0', 'DTS', 'DT', '', '', 'D'],
        'Determiner, prequalifier', ['DT0', 'ABL', 'DT', '', '', 'D'],
        'Determiner, prequantifier', ['DT0', 'ABN', 'PDT', '', 'DT', 'D'],
        'Determiner, pronoun or double conjunction', ['DT0', 'ABX', 'PDT', '', '', 'D'],
        'Determiner, pronoun or double conjunction', ['DT0', 'DTX', 'DT', '', '', 'D'],
        'Determiner, article', ['AT0', 'AT', 'DT', 'ART', '', 'D'],
        'Determiner, postdeterminer', ['DT0', 'AP', 'DT', '', '', 'D'],
        'Determiner, possessive', ['DPS', 'PP$', 'PRP$', '', '', 'D'],
        'Determiner, possessive, second', ['DPS', 'PP$', 'PRPS', '', '', 'D'],
        'Determiner, question', ['DTQ', 'WDT', 'WDT', '', 'DT', 'D'],
        'Determiner, possessive & question', ['DTQ', 'WP$', 'WP$', '', '', 'D'],
        'Interjection', ['', '', '', '', '', 'I'],
        'Localizer', ['', '', '', '', 'LC'],

        'Measure word', ['', '', '', '', 'M'],

        'Noun, common', ['NN0', 'NN', 'NN', 'N', 'NN', 'NN'],
        'Noun, singular', ['NN1', 'NN', 'NN', 'NN', 'NN', 'N'],
        'Noun, plural', ['NN2', 'NNS', 'NNS', 'NN', 'NN', 'N'],
        'Noun, proper, singular', ['NP0', 'NP', 'NNP', 'NE', 'NR', 'N'],
        'Noun, proper, plural', ['NP0', 'NPS', 'NNPS', 'NE', 'NR', 'N'],
        'Noun, adverbial', ['NN0', 'NR', 'NN', 'NE', '', 'N'],
        'Noun, adverbial, plural', ['NN2', 'NRS', 'NNS', '', 'N'],
        'Noun, temporal', ['', '', '', '', 'NT', 'N'],
        'Noun, verbal', ['', '', '', '', 'NN', 'N'],

        'Pronoun, nominal (indefinite)', ['PNI', 'PN', 'PRP', '', 'PN', 'CL'],
        'Pronoun, personal, subject', ['PNP', 'PPSS', 'PRP', 'PPER'],
        'Pronoun, personal, subject, 3SG', ['PNP', 'PPS', 'PRP', 'PPER'],
        'Pronoun, personal, object', ['PNP', 'PPO', 'PRP', 'PPER'],
        'Pronoun, reflexive', ['PNX', 'PPL', 'PRP', 'PRF'],
        'Pronoun, reflexive, plural', ['PNX', 'PPLS', 'PRP', 'PRF'],
        'Pronoun, question, subject', ['PNQ', 'WPS', 'WP', 'PWAV'],
        'Pronoun, question, subject', ['PNQ', 'WPS', 'WPS', 'PWAV'],  # Hack
        'Pronoun, question, object', ['PNQ', 'WPO', 'WP', 'PWAV', 'PWAT'],
        'Pronoun, existential there', ['EX0', 'EX', 'EX'],
        'Pronoun, attributive demonstrative', ['', '', '', 'PDAT'],
        'Prounoun, attributive indefinite without determiner', ['', '', '', 'PIAT'],
        'Pronoun, attributive possessive', ['', '', '', 'PPOSAT', ''],
        'Pronoun, substituting demonstrative', ['', '', '', 'PDS'],
        'Pronoun, substituting possessive', ['', '', '', 'PPOSS', ''],
        'Prounoun, substituting indefinite', ['', '', '', 'PIS'],
        'Pronoun, attributive relative', ['', '', '', 'PRELAT', ''],
        'Pronoun, substituting relative', ['', '', '', 'PRELS', ''],
        'Pronoun, attributive interrogative', ['', '', '', 'PWAT'],
        'Pronoun, adverbial interrogative', ['', '', '', 'PWAV'],

        'Pronoun, substituting interrogative', ['', '', '', 'PWS'],
        'Verb, main, finite', ['', '', '', 'VVFIN', '', 'V'],
        'Verb, main, infinitive', ['', '', '', 'VVINF', '', 'V'],
        'Verb, main, imperative', ['', '', '', 'VVIMP', '', 'V'],
        'Verb, base present form (not infinitive)', ['VVB', 'VB', 'VBP', '', '', 'V'],
        'Verb, infinitive', ['VVI', 'VB', 'VB', 'V', '', 'V'],
        'Verb, past tense', ['VVD', 'VBD', 'VBD', '', '', 'V'],
        'Verb, present participle', ['VVG', 'VBG', 'VBG', 'VAPP', '', 'V'],
        'Verb, past/passive participle', ['VVN', 'VBN', 'VBN', 'VVPP', '', 'V'],
        'Verb, present, 3SG, -s form', ['VVZ', 'VBZ', 'VBZ', '', '', 'V'],
        'Verb, auxiliary', ['', '', '', 'VAFIN', '', 'V'],
        'Verb, imperative', ['', '', '', 'VAIMP', '', 'V'],
        'Verb, imperative infinitive', ['', '', '', 'VAINF', '', 'V'],
        'Verb, auxiliary do, base', ['VDB', 'DO', 'VBP', '', '', 'V'],
        'Verb, auxiliary do, infinitive', ['VDB', 'DO', 'VB', '', '', 'V'],
        'Verb, auxiliary do, past', ['VDD', 'DOD', 'VBD', '', '', 'V'],
        'Verb, auxiliary do, present participle', ['VDG', 'VBG', 'VBG', '', '', 'V'],
        'Verb, auxiliary do, past participle', ['VDN', 'VBN', 'VBN', '', '', 'V'],
        'Verb, auxiliary do, present 3SG', ['VDZ', 'DOZ', 'VBZ', '', '', 'V'],
        'Verb, auxiliary have, base', ['VHB', 'HV', 'VBP', 'VA', '', 'V'],
        'Verb, auxiliary have, infinitive', ['VHI', 'HV', 'VB', 'VAINF', '', 'V'],
        'Verb, auxiliary have, past', ['VHD', 'HVD', 'VBD', 'VA', '', 'V'],
        'Verb, auxiliary have, present participle', ['VHG', 'HVG', 'VBG', 'VA', '', 'V'],
        'Verb, auxiliary have, past participle', ['VHN', 'HVN', 'VBN', 'VAPP', '', 'V'],
        'Verb, auxiliary have, present 3SG', ['VHZ', 'HVZ', 'VBZ', 'VA', '', 'V'],
        'Verb, auxiliary be, infinitive', ['VBI', 'BE', 'VB', '', '', 'V'],
        'Verb, auxiliary be, past', ['VBD', 'BED', 'VBD', '', '', 'V'],
        'Verb, auxiliary be, past, 3SG', ['VBD', 'BEDZ', 'VBD', '', '', 'V'],
        'Verb, auxiliary be, present participle', ['VBG', 'BEG', 'VBG', '', '', 'V'],
        'Verb, auxiliary be, past participle', ['VBN', 'BEN', 'VBN', '', '', 'V'],
        'Verb, auxiliary be, present, 3SG', ['VBZ', 'BEZ', 'VBZ', '', '', 'V'],
        'Verb, auxiliary be, present, 1SG', ['VBB', 'BEM', 'VBP', '', '', 'V'],
        'Verb, auxiliary be, present', ['VBB', 'BER', 'VBP', '', '', 'V'],
        'Verb, modal', ['VM0', 'MD', 'MD', 'VMFIN', 'VV', 'V'],
        'Verb, modal', ['VM0', 'MD', 'MD', 'VMINF', 'VV', 'V'],
        'Verb, modal, finite', ['', '', '', '', 'VMFIN', 'V'],
        'Verb, modal, infinite', ['', '', '', '', 'VMINF', 'V'],
        'Verb, modal, past participle', ['', '', '', '', 'VMPP', 'V'],

        'Particle', ['', '', '', '', '', 'PRT'],
        'Particle, with adverb', ['', '', '', 'PTKA', '', 'PRT'],
        'Particle, answer', ['', '', '', 'PTKANT', '', 'PRT'],
        'Particle, negation', ['', '', '', 'PTKNEG', '', 'PRT'],
        'Particle, separated verb', ['', '', '', 'PTKVZ', '', 'PRT'],
        'Particle, to as infinitive marker', ['TO0', 'TO', 'TO', 'PTKZU', '', 'PRT'],

        'Preposition, comparative', ['', '', '', 'KOKOM', '', 'P'],
        'Preposition, to', ['PRP', 'IN', 'TO', '', '', 'P'],
        'Preposition', ['PRP', 'IN', 'IN', 'APPR', 'P', 'P'],
        'Preposition, with aritcle', ['', '', '', 'APPART', '', 'P'],
        'Preposition, of', ['PRF', 'IN', 'IN', '', '', 'P'],

        'Possessive', ['POS', '$', 'POS'],

        'Postposition', ['', '', '', 'APPO'],

        'Circumposition, right', ['', '', '', 'APZR', ''],

        'Interjection, onomatopoeia or other isolate', ['ITJ', 'UH', 'UH', 'ITJ', 'IJ'],

        'Onomatopoeia', ['', '', '', '', 'ON'],

        'Punctuation', ['', '', '', '', 'PU', 'PN'],
        'Punctuation, sentence ender', ['PUN', '.', '.', '', '', 'PN'],

        'Punctuation, semicolon', ['PUN', '.', '.', '', '', 'PN'],
        'Puncutation, colon or ellipsis', ['PUN', ':', ':'],
        'Punctuationm, comma', ['PUN', ',', ',', '$,'],
        'Punctuation, dash', ['PUN', '-', '-'],
        'Punctuation, dollar sign', ['PUN', '', '$'],
        'Punctuation, left bracket', ['PUL', '(', '(', '$('],
        'Punctuation, right bracket', ['PUR', ')', ')'],
        'Punctuation, quotation mark, left', ['PUQ', '', '``'],
        'Punctuation, quotation mark, right', ['PUQ', '', '"'],

        'Punctuation, left bracket', ['PUL', '(', 'PPL'],
        'Punctuation, right bracket', ['PUR', ')', 'PPR'],
        'Punctuation, left square bracket', ['PUL', '(', 'LSB'],
        'Punctuation, right square bracket', ['PUR', ')', 'RSB'],
        'Punctuation, left curly bracket', ['PUL', '(', 'LCB'],
        'Punctuation, right curly bracket', ['PUR', ')', 'RCB'],

        'Unknown, foreign words (not in lexicon)', ['UNZ', '(FW-)', 'FW', '', 'FW'],

        'Symbol', ['', '', 'SYM', 'XY'],
        'Symbol, alphabetical', ['ZZ0', '', ''],
        'Symbol, list item', ['', '', 'LS'],

        # Not sure about these tags from the Chinese PTB.
        'Aspect marker', ['', '', '', '', 'AS'],                         # ?
        'Ba-construction', ['', '', '', '', 'BA'],                       # ?
        'In relative', ['', '', '', '', 'DEC'],                          # ?
        'Associative', ['', '', '', '', 'DER'],                          # ?
        'In V-de or V-de-R construct', ['', '', '', '', 'DER'],          # ?
        'For words ? ', ['', '', '', '', 'ETC'],                         # ?
        'In long bei-construct', ['', '', '', '', 'LB'],                 # ?
        'In short bei-construct', ['', '', '', '', 'SB'],                # ?
        'Sentence-nal particle', ['', '', '', '', 'SB'],                 # ?
        'Particle, other', ['', '', '', '', 'MSP'],                      # ?
        'Before VP', ['', '', '', '', 'DEV'],                            # ?
        'Verb, ? as main verb', ['', '', '', '', 'VE'],                  # ?
        'Verb, ????', ['', '', '', '', 'VC']                             # ?
      ]},
      enju: {cat_to_category: {
        'ADJ' => 'adjective',
        'ADV' => 'adverb',
        'CONJ' => 'conjunction',
        'COOD' => 'conjunction',
        'C' => 'complementizer',
        'D' => 'determiner',
        'N' => 'noun',
        'P' => 'preposition',
        'PN' => 'punctuation',
        'SC' => 'conjunction',
        'V' => 'verb',
        'PRT' => 'particle'
      },
      cat_to_description: [
        ['ADJ',	'Adjective'],
        ['ADV',	'Adverb'],
        ['CONJ',	'Coordination conjunction'],
        ['C',	'Complementizer'],
        ['D',	'Determiner'],
        ['N',	'Noun'],
        ['P',	'Preposition'],
        ['SC',	'Subordination conjunction'],
        ['V',	'Verb'],
        ['COOD',	'Part of coordination'],
        ['PN',	'Punctuation'],
        ['PRT',	'Particle'],
        ['S',	'Sentence']
      ],
      xcat_to_description: [
        ['COOD',	'Coordinated phrase/clause'],
        ['IMP',	'Imperative sentence'],
        ['INV',	'Subject-verb inversion'],
        ['Q',	'Interrogative sentence with subject-verb inversion'],
        ['REL',	'A relativizer included'],
        ['FREL', 'A free relative included'],
        ['TRACE',	'A trace included'],
        ['WH', 'A wh-question word included']
      ],
      xcat_to_ptb: [
        ['ADJP', '', 'ADJP'],
        ['ADJP', 'REL', 'WHADJP'],
        ['ADJP', 'FREL', 'WHADJP'],
        ['ADJP', 'WH', 'WHADJP'],
        ['ADVP', '', 'ADVP'],
        ['ADVP', 'REL', 'WHADVP'],
        ['ADVP', 'FREL', 'WHADVP'],
        ['ADVP', 'WH', 'WHADVP'],
        ['CONJP', '', 'CONJP'],
        ['CP', '', 'SBAR'],
        ['DP', '', 'NP'],
        ['NP', '', 'NP'],
        ['NX', 'NX', 'NAC'],
        ['NP'	'REL'	'WHNP'],
        ['NP'	'FREL'	'WHNP'],
        ['NP'	'WH'	'WHNP'],
        ['PP', '', 'PP'],
        ['PP', 'REL', 'WHPP'],
        ['PP', 'WH', 'WHPP'],
        ['PRT', '', 'PRT'],
        ['S', '', 'S'],
        ['S', 'INV', 'SINV'],
        ['S', 'Q', 'SQ'],
        ['S', 'REL', 'SBAR'],
        ['S', 'FREL', 'SBAR'],
        ['S', 'WH', 'SBARQ'],
        ['SCP', '', 'SBAR'],
        ['VP', '', 'VP'],
        ['VP', '', 'VP'],
        ['', '', 'UK']
      ]}},
      paris7: {tag_to_category: {
        'C' => :complementizer,
        'PN' => :punctuation,
        'SC' => :conjunction
      }
      # Paris7 Treebank functional tags
=begin
    SUJ (subject)
    OBJ (direct object)
    ATS (predicative complement of a subject)
    ATO (predicative complement of a direct object)
    MOD (modifier or adjunct)
    A-OBJ (indirect complement introduced by à)
    DE-OBJ (indirect complement introduced by de)
    P-OBJ (indirect complement introduced by another preposition)
=end
    },
    ptb: {escape_characters: {
      '(' => '-LRB-',
      ')' => '-RRB-',
      '[' => '-LSB-',
      ']' => '-RSB-',
      '{' => '-LCB-',
      '}' => '-RCB-'
    },
    phrase_tag_to_description: [
      ['S', 'Paris7 declarative clause'],
      ['SBAR', 'Clause introduced by a (possibly empty) subordinating conjunction'],
      ['SBARQ', 'Direct question introduced by a wh-word or a wh-phrase'],
      ['SINV', 'Inverted declarative sentence'],
      ['SQ', 'Inverted yes/no question']
    ]}
    
  }
end