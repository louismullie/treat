# Stem a word using a native Ruby implementation of the
# Porter stemming algorithm, ported to Ruby from a
# version coded up in Perl. This is a simplified
# implementation; for a true and fast Porter stemmer,
# see Treat::Workers::Inflectors::Stemmers::PorterC.
#
# Authored by Ray Pereda (raypereda@hotmail.com).
# Unknown license.
#
# Original paper: Porter, 1980. An algorithm for suffix stripping,
# Program, Vol. 14, no. 3, pp 130-137,
# Original C implementation: http://www.tartarus.org/~martin/PorterStemmer.
class Treat::Workers::Inflectors::Stemmers::Porter
  
  # Returns the stem of a word using a native Porter stemmer.
  #
  # Options: none.
  def self.stem(word, options = {})
    # Copy the word and convert it to a string.
    w = word.to_s
    return w if w.length < 3
    # Map initial y to Y so that the patterns
    # never treat it as vowel.
    w[0] = 'Y' if w[0] == ?y
    # Step 1a
    if w =~ /(ss|i)es$/
      w = $` + $1
    elsif w =~ /([^s])s$/
      w = $` + $1
    end
    # Step 1b
    if w =~ /eed$/
      w.chop! if $` =~ MGR0
    elsif w =~ /(ed|ing)$/
      stem = $`
      if stem =~ VOWEL_IN_STEM
        w = stem
        case w
        when /(at|bl|iz)$/             then w << "e"
        when /([^aeiouylsz])\1$/       then w.chop!
        when /^#{CC}#{V}[^aeiouwxy]$/o then w << "e"
        end
      end
    end
    if w =~ /y$/
      stem = $`
      w = stem + "i" if stem =~ VOWEL_IN_STEM
    end
    # Step 2
    if w =~ SUFFIX_1_REGEXP
      stem = $`
      suffix = $1
      if stem =~ MGR0
        w = stem + STEP_2_LIST[suffix]
      end
    end
    # Step 3
    if w =~
      /(icate|ative|alize|iciti|ical|ful|ness)$/
      stem = $`
      suffix = $1
      if stem =~ MGR0
        w = stem + STEP_3_LIST[suffix]
      end
    end
    # Step 4
    if w =~ SUFFIX_2_REGEXP
      stem = $`
      if stem =~ MGR1
        w = stem
      end
    elsif w =~ /(s|t)(ion)$/
      stem = $` + $1
      if stem =~ MGR1
        w = stem
      end
    end
    #  Step 5
    if w =~ /e$/
      stem = $`
      if (stem =~ MGR1) ||
        (stem =~ MEQ1 && stem !~
        /^#{CC}#{V}[^aeiouwxy]$/o)
        w = stem
      end
    end
    if w =~ /ll$/ && w =~ MGR1
      w.chop!
    end
    # and turn initial Y back to y
    w[0] = 'y' if w[0] == ?Y
    w
  end

  STEP_2_LIST = {
    'ational'=>'ate', 'tional'=>'tion', 'enci'=>'ence', 'anci'=>'ance',
    'izer'=>'ize', 'bli'=>'ble',
    'alli'=>'al', 'entli'=>'ent', 'eli'=>'e', 'ousli'=>'ous',
    'ization'=>'ize', 'ation'=>'ate',
    'ator'=>'ate', 'alism'=>'al', 'iveness'=>'ive', 'fulness'=>'ful',
    'ousness'=>'ous', 'anati'=>'al',
    'iviti'=>'ive', 'binati'=>'ble', 'logi'=>'log'
  }
  
  STEP_3_LIST = {
    'icate'=>'ic', 'ative'=>'', 'alize'=>'al', 'iciti'=>'ic',
    'ical'=>'ic', 'ful'=>'', 'ness'=>''
  }
  
  SUFFIX_1_REGEXP = /(
  ational  |
  tional   |
  enci     |
  anci     |
  izer     |
  bli      |
  alli     |
  entli    |
  eli      |
  ousli    |
  ization  |
  ation    |
  ator     |
  alism    |
  iveness  |
  fulness  |
  ousness  |
  anati    |
  iviti    |
  binati   |
  logi)$/x
  SUFFIX_2_REGEXP = /(
  al       |
  ance     |
  ence     |
  er       |
  ic       |
  able     |
  ible     |
  ant      |
  ement    |
  ment     |
  ent      |
  ou       |
  ism      |
  ate      |
  iti      |
  ous      |
  ive      |
  ize)$/x
  C = "[^aeiou]"         # consonant
  V = "[aeiouy]"         # vowel
  CC = "#{C}(?>[^aeiouy]*)"  # consonant sequence
  VV = "#{V}(?>[aeiou]*)"    # vowel sequence
  MGR0 = /^(#{CC})?#{VV}#{CC}/o                # [cc]vvcc... is m>0
  MEQ1 = /^(#{CC})?#{VV}#{CC}(#{VV})?$/o       # [cc]vvcc[vv] is m=1
  MGR1 = /^(#{CC})?#{VV}#{CC}#{VV}#{CC}/o      # [cc]vvccvvcc... is m>1
  VOWEL_IN_STEM   = /^(#{CC})?#{V}/o                      # vowel in stem
  
end