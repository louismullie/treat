module Treat
  module Languages
    class English

      ClawsC5 = 0
      Brown = 1
      Penn = 2

      PTBClauseTagDescription = [
        ['S', 'Simple declarative clause'],
        ['SBAR', 'Clause introduced by a (possibly empty) subordinating conjunction'],
        ['SBARQ', 'Direct question introduced by a wh-word or a wh-phrase'],
        ['SINV', 'Inverted declarative sentence'],
        ['SQ', 'Inverted yes/no question']
      ]

      AlignedPhraseTags = 
      [
        'Adjective phrase', ['ADJP'],
        'Adverb phrase', ['ADVP'],
        'Conjunction phrase', ['CONJP'],
        'Fragment', ['FRAG'],
        'Interjection', ['INTJ'],
        'List marker', ['LST'],
        'Not a phrase', ['NAC'],
        'Noun phrase', ['NP'],
        'Head of NP', ['NX'],
        'Prepositional phrase', ['PP'],
        'Parenthetical', ['PRN'],
        'Particle', ['PRT'],
        'Quantifier phrase', ['QP'],
        'Reduced relative clause', ['RRC'],
        'Unlike coordinated phrase', ['UCP'],
        'Verb phrase', ['VP'],
        'Wh adjective phrase', ['WHADJP'],
        'Wh adverb phrase', ['WHAVP'],
         'Wh noun phrase', ['WHNP'],
        'Wh prepositional phrase', ['WHPP'],
        'Unknown', ['X'],
        'Generic phrase', ['P']
      ]
      

      PTBWordTagDescription = [
        ['CC', 'Coordinating conjunction'],
        ['CD', 'Cardinal number'],
        ['DT', 'Determiner'],
        ['EX', 'Existential there'],
        ['FW', 'Foreign word'],
        ['IN', 'Preposition or subordinating conjunction'],
        ['JJ', 'Adjective'],
        ['JJR', 'Adjective, comparative'],
        ['JJS', 'Adjective, superlative'],
        ['LS', 'List item marker'],
        ['MD', 'Modal'],
        ['NN', 'Noun, singular or mass'],
        ['NNS', 'Noun, plural'],
        ['NNP', 'Proper noun, singular'],
        ['NNPS', 'Proper noun, plural'],
        ['PDT', 'Predeterminer'],
        ['POS', 'Possessive ending'],
        ['PRP', 'Personal pronoun'],
        ['PRP$', 'Possessive pronoun (prolog version PRP-S)'],
        ['RB', 'Adverb'],
        ['RBR', 'Adverb, comparative'],
        ['RBS', 'Adverb, superlative'],
        ['RP', 'Particle'],
        ['SYM', 'Symbol'],
        ['TO', 'to'],
        ['UH', 'Interjection'],
        ['VB', 'Verb, base form'],
        ['VBD', 'Verb, past tense'],
        ['VBG', 'Verb, gerund or present participle'],
        ['VBN', 'Verb, past participle'],
        ['VBP', 'Verb, non 3rd person singular present'],
        ['VBZ', 'Verb, 3rd person singular present'],
        ['WDT', 'Wh-determiner'],
        ['WP', 'Wh-pronoun'],
        ['WP$', 'Possessive wh-pronoun (prolog version WP-S)'],
        ['WRB', 'Wh-adverb']
      ]
      
      BrownWordTagDescription = [

        ['.',	'sentence closer	. ; ? !'],
        ['(',	'left parent']	 ,
        [')',	'right parent'],
        ['*',	'not'],
        ['--',	'dash'],
        [',',	'comma'],
        [':',	'colon'],
        ['ABL', 'pre-qualifier	quite, rather'],
        ['ABN', 'pre-quantifier	half, all'],
        ['ABX', 'pre-quantifier	both'],
        ['AP', 'post-determiner	many, several, next'],
        ['AT', 'article	a, the, no'],
        ['BE', 'be	 '],
        ['BED', 'were	 '],
        ['BEDZ', 'was	 '],
        ['BEG', 'being	 '],
        ['BEM', 'am	 '],
        ['BEN', 'been	 '],
        ['BER', 'are, art	 '],
        ['BEZ', 'is	 '],
        ['CC', 'coordinating conjunction	and, or'],
        ['CD', 'cardinal numeral	one, two, 2, etc.'],
        ['CS', 'subordinating conjunction	if, although'],
        ['DO', 'do	 '],
        ['DOD', 'did	 '],
        ['DOZ', 'does	 '],
        ['DT', 'singular determiner	this, that'],
        ['DTI', 'singular or plural determiner/quantifier	some, any'],
        ['DTS', 'plural determiner	these, those'],
        ['DTX', 'determiner/double conjunction	either'],
        ['EX', 'existentil there	 '],
        ['FW', 'foreign word (hyphenated before regular tag)	 '],
        ['HL', 'word occurring in headline (hyphenated after regular tag)	 '],
        ['HV', 'have	 '],
        ['HVD', 'had (past tense)	 '],
        ['HVG', 'having	 '],
        ['HVN', 'had (past participle)	 '],
        ['HVZ', 'has	 '],
        ['IN', 'preposition	 '],
        ['JJ', 'adjective	 '],
        ['JJR', 'comparative adjective	 '],
        ['JJS', 'semantically superlative adjective	 chief, top'],
        ['JJT', 'morphologically superlative adjective	biggest'],
        ['MD', 'modal auxiliary	can, should, will'],
        ['NC', 'cited word (hyphenated after regular tag)	 '],
        ['NN', 'singular or mass noun	 '],
        ['NN$', 'possessive singular noun	 '],
        ['NNS', 'plural noun	 '],
        ['NNS$', 'possessive plural noun	 '],
        ['NP', 'proper noun or part of name phrase	 '],
        ['NP$', 'possessive proper noun	 '],
        ['NPS', 'plural proper noun	 '],
        ['NPS$', 'possessive plural proper noun	 '],
        ['NR', 'adverbial noun	home, today, west'],
        ['NRS', 'plural adverbial noun'],
        ['OD', 'ordinal numeral	first, 2nd'],
        ['PN', 'nominal pronoun	everybody, nothing'],
        ['PN$', 'possessive nominal pronoun	 '],
        ['PP$', 'possessive personal pronoun	my, our'],
        ['PP$$', 'second (nominal) possessive pronoun	mine, ours'],
        ['PPL', 'singular reflexive/intensive personal pronoun	myself'],
        ['PPLS', 'plural reflexive/intensive personal pronoun	ourselves'],
        ['PPO', 'objective personal pronoun	me, him, it, them'],
        ['PPS', '3rd. singular nominative pronoun	he, she, it, one'],
        ['PPSS', 'other nominative personal pronoun	I, we, they, you'],
        ['QL', 'qualifier	very, fairly'],
        ['QLP', 'post-qualifier	enough, indeed'],
        ['RB', 'adverb	 '],
        ['RBR', 'comparative adverb	 '],
        ['RBT', 'superlative adverb	 '],
        ['RN', 'nominal adverb	here then, indoors	 '],
        ['RP', 'adverb/particle	about, off, up'],
        ['TL', 'word occurring in title (hyphenated after regular tag)'],
        ['TO', 'infinitive marker to	 '],
        ['UH', 'interjection, exclamation	 '],
        ['VB', 'verb, base form	 '],
        ['VBD', 'verb, past tense	 '],
        ['VBG', 'verb, present participle/gerund	 '],
        ['VBN', 'verb, past participle	 '],
        ['VBZ', 'verb, 3rd. singular present	 '],
        ['WDT', 'wh- determiner	what, which'],
        ['WP$', 'possessive wh- pronoun	whose'],
        ['WPO', 'objective wh- pronoun	whom, which, that'],
        ['WPS', 'nominative wh- pronoun	who, which, that'],
        ['WQL', 'wh- qualifier	how'],
        ['WRB', 'wh- adverb	how, where, when']

      ]
      # A description of Enju categories.
      EnjuCatDescription = [
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
      ]
      
      # Maps Enju categories to Treat categories.
      EnjuCatToCategory = {
        'ADJ' => :adjective,
        'ADV' => :adverb,
        'CONJ' => :conjunction,
        'COOD' => :conjunction,
        'C' => :complementizer,
        'D' => :determiner,
        'N' => :noun,
        'P' => :preposition,
        'PN' => :punctuation,
        'SC' => :conjunction,
        'V' => :verb,
        'PRT' => :particle
      }

      # Description of the xcat in the Enju output specification.
      EnjuXCatDescription = [
        ['COOD',	'Coordinated phrase/clause'],
        ['IMP',	'Imperative sentence'],
        ['INV',	'Subject-verb inversion'],
        ['Q',	'Interrogative sentence with subject-verb inversion'],
        ['REL',	'A relativizer included'],
        ['FREL', 'A free relative included'],
        ['TRACE',	'A trace included'],
        ['WH', 'A wh-question word included']
      ]

      EnjuCatXcatToPTB = [
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
      ]

      # Aligned tags for the Claws C5, Brown and Penn tag sets.
      # Adapted from Manning, Christopher and Schütze, Hinrich,
      # 1999. Foundations of Statistical Natural Language
      # Processing. MIT Press, p. 141-142.
      AlignedWordTags = [
        'Adjective', ['AJ0', 'JJ', 'JJ'],
        'Adjective, ordinal number', ['ORD', 'OD', 'JJ'],
        'Adjective, comparative', ['AJC', 'JJR', 'JJR'],
        'Adjective, superlative', ['AJS', 'JJT', 'JJS'],
        'Adjective, superlative, semantically', ['AJ0', 'JJS', 'JJ'],
        'Adjective, cardinal number', ['CRD', 'CD', 'CD'],
        'Adjective, cardinal number, one', ['PNI', 'CD', 'CD'],
        'Adverb', ['AV0', 'RB', 'RB'],
        'Adverb, negative', ['XX0', '*', 'RB'],
        'Adverb, comparative', ['AV0', 'RBR', 'RBR'],
        'Adverb, superlative', ['AV0', 'RBT', 'RBS'],
        'Adverb, particle', ['AVP', 'RP', 'RP'],
        'Adverb, question', ['AVQ', 'WRB', 'WRB'],
        'Adverb, degree & question', ['AVQ', 'WQL', 'WRB'],
        'Adverb, degree', ['AV0', 'QL', 'RB'],
        'Adverb, degree, postposed', ['AV0', 'QLP', 'RB'],
        'Adverb, nominal', ['AV0', 'RN', 'RB'],
        'Conjunction, coordination', ['CJC', 'CC', 'CC'],
        'Conjunction, subordination', ['CJS', 'CS', 'IN'],
        'Conjunction, complementizer, that', ['CJT', 'CS', 'IN'],
        'Determiner', ['DT0', 'DT', 'DT'],
        'Determiner', ['DT0', 'DT', 'DET'],
        'Determiner, pronoun', ['DT0', 'DTI', 'DT'],
        'Determiner, pronoun, plural', ['DT0', 'DTS', 'DT'],
        'Determiner, prequalifier', ['DT0', 'ABL', 'DT'],
        'Determiner, prequantifier', ['DT0', 'ABN', 'PDT'],
        'Determiner, pronoun or double conjunction', ['DT0', 'ABX', 'PDT'],
        'Determiner, pronoun or double conjunction', ['DT0', 'DTX', 'DT'],
        'Determiner, article', ['AT0', 'AT', 'DT'],
        'Determiner, postdeterminer', ['DT0', 'AP', 'DT'],
        'Determiner, possessive', ['DPS', 'PP$', 'PRP$'],
        'Determiner, possessive, second', ['DPS', 'PPSS', 'PRPS'],
        'Determiner, possessive, second', ['DPS', 'PP$$', 'PRP'],
        'Determiner, possessive, second', ['DPS', 'PPSS', 'PRP'],
        'Determiner, question', ['DTQ', 'WDT', 'WDT'],
        'Determiner, possessive & question', ['DTQ', 'WP$', 'WP$'],
        'Determiner, possessive & question', ['DTQ', 'WPS', 'WPS'],
        'Noun', ['NN0', 'NN', 'NN'],
        'Noun, singular', ['NN1', 'NN', 'NN'],
        'Noun, plural', ['NN2', 'NNS', 'NNS'],
        'Noun, proper, singular', ['NP0', 'NP', 'NNP'],
        'Noun, proper, plural', ['NP0', 'NPS', 'NNPS'],
        'Noun, adverbial', ['NN0', 'NR', 'NN'],
        'Noun, adverbial, plural', ['NN2', 'NRS', 'NNS'],
        'Pronoun, nominal (indefinite)', ['PNI', 'PN', 'PRP'],
        'Pronoun, personal, subject', ['PNP', 'PPSS', 'PRP'],
        'Pronoun, personal, subject, 3SG', ['PNP', 'PPS', 'PRP'],
        'Pronoun, personal, object', ['PNP', 'PPO', 'PRP'],
        'Pronoun, reflexive', ['PNX', 'PPL', 'PRP'],
        'Pronoun, reflexive, plural', ['PNX', 'PPLS', 'PRP'],
        'Pronoun, question, subject', ['PNQ', 'WPS', 'WP'],
        'Pronoun, question, object', ['PNQ', 'WPO', 'WP'],
        'Pronoun, existential there', ['EX0', 'EX', 'EX'],
        'Verb, base present form (not infinitive)', ['VVB', 'VB', 'VBP'],
        'Verb, infinitive', ['VVI', 'VB', 'VB'],
        'Verb, past tense', ['VVD', 'VBD', 'VBD'],
        'Verb, present participle', ['VVG', 'VBG', 'VBG'],
        'Verb, past/passive participle', ['VVN', 'VBN', 'VBN'],
        'Verb, present, 3SG, -s form', ['VVZ', 'VBZ', 'VBZ'],
        'Verb, auxiliary do, base', ['VDB', 'DO', 'VBP'],
        'Verb, auxiliary do, infinitive', ['VDB', 'DO', 'VB'],
        'Verb, auxiliary do, past', ['VDD', 'DOD', 'VBD'],
        'Verb, auxiliary do, present participle', ['VDG', 'VBG', 'VBG'],
        'Verb, auxiliary do, past participle', ['VDN', 'VBN', 'VBN'],
        'Verb, auxiliary do, present 3SG', ['VDZ', 'DOZ', 'VBZ'],
        'Verb, auxiliary have, base', ['VHB', 'HV', 'VBP'],
        'Verb, auxiliary have, infinitive', ['VHI', 'HV', 'VB'],
        'Verb, auxiliary have, past', ['VHD', 'HVD', 'VBD'],
        'Verb, auxiliary have, present participle', ['VHG', 'HVG', 'VBG'],
        'Verb, auxiliary have, past participle', ['VHN', 'HVN', 'VBN'],
        'Verb, auxiliary have, present 3SG', ['VHZ', 'HVZ', 'VBZ'],
        'Verb, auxiliary be, infinitive', ['VBI', 'BE', 'VB'],
        'Verb, auxiliary be, past', ['VBD', 'BED', 'VBD'],
        'Verb, auxiliary be, past, 3SG', ['VBD', 'BEDZ', 'VBD'],
        'Verb, auxiliary be, present participle', ['VBG', 'BEG', 'VBG'],
        'Verb, auxiliary be, past participle', ['VBN', 'BEN', 'VBN'],
        'Verb, auxiliary be, present, 3SG', ['VBZ', 'BEZ', 'VBZ'],
        'Verb, auxiliary be, present, 1SG', ['VBB', 'BEM', 'VBP'],
        'Verb, auxiliary be, present', ['VBB', 'BER', 'VBP'],
        'Verb, modal', ['VM0', 'MD', 'MD'],
        'Preposition, to as infinitive marker', ['TO0', 'TO', 'TO'],
        'Preposition, to', ['PRP', 'IN', 'TO'],
        'Preposition', ['PRP', 'IN', 'IN'],
        'Preposition, of', ['PRF', 'IN', 'IN'],
        'Possessive', ['POS', '$', 'POS'],
        'Interjection (or other isolate)', ['ITJ', 'UH', 'UH'],
        'Punctuation, sentence ender', ['PUN', '.', '.'],
        'Punctuation, sentence ender', ['PUN', '.', 'PP'],
        'Punctuation, semicolon', ['PUN', '.', '.'],
        'Puncutation, colon or ellipsis', ['PUN', ':', ':'],
        'Punctuationm, comma', ['PUN', ',', ','],
        'Punctuation, dash', ['PUN', '-', '-'],
        'Punctuation, dollar sign', ['PUN', '', '$'],
        'Punctuation, left bracket', ['PUL', '(', '('],
        'Punctuation, right bracket', ['PUR', ')', ')'],
        'Punctuation, quotation mark, left', ['PUQ', '', '``'],
        'Punctuation, quotation mark, right', ['PUQ', '', '"'],
        'Unknown, foreign words (not in English lexicon)', ['UNZ', '(FW-)', 'FW'],
        'Symbol', ['', '', 'SYM'],
        'Symbol, alphabetical', ['ZZ0', '', ''],
        'Symbol, list item', ['', '', 'LS']
      ]
      
      wttc = {}
      Treat::Languages::English::AlignedWordTags.each_slice(2) do |desc, tags|
        category = desc.gsub(',', ' ,').split(' ')[0].downcase.intern
        wttc[tags[0]] ||= {}; wttc[tags[1]] ||= {} ;wttc[tags[2]] ||= {}
        wttc[tags[0]][:claws_5] = category
        wttc[tags[1]][:brown] = category
        wttc[tags[2]][:penn] = category
      end
      # A hash converting word tags to word categories.
      WordTagToCategory = wttc
      
      # A hash converting phrase tag to categories.
      pttc = {}
      Treat::Languages::English::AlignedPhraseTags.each_slice(2) do |desc, tags|
        category = desc.gsub(',', ' ,').gsub(' ', '_').downcase.intern
        pttc[tags[0]] ||= {};
        #pttc[tags[0]][:claws_5] = category
        #pttc[tags[1]][:brown] = category
        pttc[tags[0]][:penn] = category
      end
      # A hash converting word tags to word categories.
      PhraseTagToCategory = pttc
      
      SentenceTags = 
      {
        penn: 'S'
      }
    end
  end
end
