module Treat
  module Inflectors
    module Declensions
      # This class is a wrapper for the Inflect module,
      # copied from the unmaintained 'english' ruby gem,
      # created by Thomas Sawyer.
      # 
      # Released under the MIT License.
      #
      #  http://english.rubyforge.org
      class English
        # Retrieve the declensions (singular, plural)
        # of an english word using a class lifted from
        # the 'english' ruby gem.
        def self.declensions(entity, options)
          unless options[:count]
            raise Treat::Exception, 
            "Must supply option count (:singular or :plural)."
          end
          string = entity.to_s
          if entity.category == :verb
            raise Treat::Exception,
            "Cannot retrieve the declensions of a verb. " +
            "Use #singular_verb and #plural_verb instead."
          elsif options[:count] == :plural
            Inflect.plural(string)
          elsif options[:count] == :singular
            Inflect.singular(string)
          else
            {singular: Inflect.singular(string),
             plural: Inflect.plural(string)}
          end
        end

        module Inflect

          @singular_of = {}
          @plural_of = {}

          @singular_rules = []
          @plural_rules = []

          # This class provides the DSL for creating inflections, you can add additional rules.
          # Examples:
          #
          #   word "ox", "oxen"
          #   word "octopus", "octopi"
          #   word "man", "men"
          #
          #   rule "lf", "lves"
          #
          #   word "equipment"
          #
          # Rules are evaluated by size, so rules you add to override specific cases should be longer than the rule
          # it overrides. For instance, if you want "pta" to pluralize to "ptas", even though a general purpose rule
          # for "ta" => "tum" already exists, simply add a new rule for "pta" => "ptas", and it will automatically win
          # since it is longer than the old rule.
          #
          # Also, single-word exceptions win over general words ("ox" pluralizes to "oxen", because it's a single word
          # exception, even though "fox" pluralizes to "foxes")
          class << self
            # Define a general two-way exception.
            #
            # This also defines a general rule, so foo_child will correctly become
            # foo_children.
            #
            # Whole words also work if they are capitalized (Goose => Geese).
            def word(singular, plural=nil)
              plural = singular unless plural
              singular_word(singular, plural)
              plural_word(singular, plural)
              rule(singular, plural)
            end

            # Define a singularization exception.
            def singular_word(singular, plural)
              @singular_of[plural] = singular
              @singular_of[plural.capitalize] = singular.capitalize
            end

            # Define a pluralization exception.
            def plural_word(singular, plural)
              @plural_of[singular] = plural
              @plural_of[singular.capitalize] = plural.capitalize
            end

            # Define a general rule.
            def rule(singular, plural)
              singular_rule(singular, plural)
              plural_rule(singular, plural)
            end

            # Define a singularization rule.
            def singular_rule(singular, plural)
              @singular_rules << [singular, plural]
            end

            # Define a plurualization rule.
            def plural_rule(singular, plural)
              @plural_rules << [singular, plural]
            end

            # Read prepared singularization rules.
            def singularization_rules
              if defined?(@singularization_regex) && @singularization_regex
                return [@singularization_regex, @singularization_hash]
              end
              # No sorting needed: Regexen match on longest string
              @singularization_regex = Regexp.new("(" + @singular_rules.map {|s,p| p}.join("|") + ")$", "i")
              @singularization_hash  = Hash[*@singular_rules.flatten].invert
              [@singularization_regex, @singularization_hash]
            end

            # Read prepared singularization rules.
            #def singularization_rules
            #  return @singularization_rules if @singularization_rules
            #  sorted = @singular_rules.sort_by{ |s, p| "#{p}".size }.reverse
            #  @singularization_rules = sorted.collect do |s, p|
            #    [ /#{p}$/, "#{s}" ]
            #  end
            #end

            # Read prepared pluralization rules.
            def pluralization_rules
              if defined?(@pluralization_regex) && @pluralization_regex
                return [@pluralization_regex, @pluralization_hash]
              end
              @pluralization_regex = Regexp.new("(" + @plural_rules.map {|s,p| s}.join("|") + ")$", "i")
              @pluralization_hash = Hash[*@plural_rules.flatten]
              [@pluralization_regex, @pluralization_hash]
            end

            # Read prepared pluralization rules.
            #def pluralization_rules
            #  return @pluralization_rules if @pluralization_rules
            #  sorted = @plural_rules.sort_by{ |s, p| "#{s}".size }.reverse
            #  @pluralization_rules = sorted.collect do |s, p|
            #    [ /#{s}$/, "#{p}" ]
            #  end
            #end

            #
            def singular_of ; @singular_of ; end

            #
            def plural_of   ; @plural_of   ; end

            # Convert an English word from plurel to singular.
            #
            #   "boys".singular      #=> boy
            #   "tomatoes".singular  #=> tomato
            #
            def singular(word)
              return "" if word == ""
              if result = singular_of[word]
                return result.dup
              end
              result = word.dup

              regex, hash = singularization_rules
              result.sub!(regex) {|m| hash[m]}
              singular_of[word] = result
              return result
              #singularization_rules.each do |(match, replacement)|
              #  break if result.gsub!(match, replacement)
              #end
              #return result
            end

            # Alias for #singular (a Railism).
            #
            alias_method(:singularize, :singular)

            # Convert an English word from singular to plurel.
            #
            #   "boy".plural     #=> boys
            #   "tomato".plural  #=> tomatoes
            #
            def plural(word)
              return "" if word == ""
              if result = plural_of[word]
                return result.dup
              end
              #return self.dup if /s$/ =~ self # ???
              result = word.dup

              regex, hash = pluralization_rules
              result.sub!(regex) {|m| hash[m]}
              plural_of[word] = result
              return result
              #pluralization_rules.each do |(match, replacement)|
              #  break if result.gsub!(match, replacement)
              #end
              #return result
            end

            # Alias for #plural (a Railism).
            alias_method(:pluralize, :plural)

            # Clear all rules.
            def clear(type = :all)
              if type == :singular || type == :all
                @singular_of = {}
                @singular_rules = []
                @singularization_rules, @singularization_regex = nil, nil
              end
              if type == :plural || type == :all
                @singular_of = {}
                @singular_rules = []
                @singularization_rules, @singularization_regex = nil, nil
              end
            end
          end

          # One argument means singular and plural are the same.

          word 'equipment'
          word 'information'
          word 'money'
          word 'species'
          word 'series'
          word 'fish'
          word 'sheep'
          word 'moose'
          word 'hovercraft'
          word 'news'
          word 'rice'
          word 'plurals'

          # Two arguments defines a singular and plural exception.

          word 'Swiss'     , 'Swiss'
          word 'alias'     , 'aliases'
          word 'analysis'  , 'analyses'
          #word 'axis'      , 'axes'
          word 'basis'     , 'bases'
          word 'buffalo'   , 'buffaloes'
          word 'child'     , 'children'
          #word 'cow'       , 'kine'
          word 'crisis'    , 'crises'
          word 'criterion' , 'criteria'
          word 'datum'     , 'data'
          word 'goose'     , 'geese'
          word 'hive'      , 'hives'
          word 'index'     , 'indices'
          word 'life'      , 'lives'
          word 'louse'     , 'lice'
          word 'man'       , 'men'
          word 'matrix'    , 'matrices'
          word 'medium'    , 'media'
          word 'mouse'     , 'mice'
          word 'movie'     , 'movies'
          word 'octopus'   , 'octopi'
          word 'ox'        , 'oxen'
          word 'person'    , 'people'
          word 'potato'    , 'potatoes'
          word 'quiz'      , 'quizzes'
          word 'shoe'      , 'shoes'
          word 'status'    , 'statuses'
          word 'testis'    , 'testes'
          word 'thesis'    , 'theses'
          word 'thief'     , 'thieves'
          word 'tomato'    , 'tomatoes'
          word 'torpedo'   , 'torpedoes'
          word 'vertex'    , 'vertices'
          word 'virus'     , 'viri'
          word 'wife'      , 'wives'

          # One-way singularization exception (convert plural to singular).

          singular_word 'cactus', 'cacti'

          # One-way pluralizaton exception (convert singular to plural).

          plural_word 'axis', 'axes'

          # General rules.

          rule 'rf'     , 'rves'
          rule 'ero'    , 'eroes'
          rule 'ch'     , 'ches'
          rule 'sh'     , 'shes'
          rule 'ss'     , 'sses'
          #rule 'ess'  , 'esses'
          rule 'ta'     , 'tum'
          rule 'ia'     , 'ium'
          rule 'ra'     , 'rum'
          rule 'ay'     , 'ays'
          rule 'ey'     , 'eys'
          rule 'oy'     , 'oys'
          rule 'uy'     , 'uys'
          rule 'y'      , 'ies'
          rule 'x'      , 'xes'
          rule 'lf'     , 'lves'
          rule 'ffe'    , 'ffes'
          rule 'af'     , 'aves'
          rule 'us'     , 'uses'
          rule 'ouse'   , 'ouses'
          rule 'osis'   , 'oses'
          rule 'ox'     , 'oxes'
          rule ''       , 's'

          # One-way singular rules.

          singular_rule 'of' , 'ofs' # proof
          singular_rule 'o'  , 'oes' # hero, heroes
          #singular_rule 'f'  , 'ves'

          # One-way plural rules.

          plural_rule 's'   , 'ses'
          plural_rule 'ive' , 'ives' # don't want to snag wife
          plural_rule 'fe'  , 'ves'  # don't want to snag perspectives
          
        end
      end
    end
  end
end
