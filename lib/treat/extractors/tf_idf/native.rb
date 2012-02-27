# Calculates the TF*IDF score of words.
module Treat::Extractors::TfIdf::Native
  DefaultOptions = {
    :tf => :natural,
    :idf => :logarithm,
    :remove_common_words => true,
    :precision => 4
  }
  Algorithms = {
    :tf => {
      :natural => lambda { |tf| tf },
      :logarithm => lambda { |tf| Math.log(1 + tf) },
      :sqrt =>lambda { |tf| Math.sqrt(tf) }
    },
    :idf => {
      :logarithm => lambda { |n,df| Math.log(n/(1 + df)) },
      :none => lambda { |n,idf| 1 }
    }
  }
  # Optimization caches for tf idf.
  @@n = {} # Number of documents in the collection (n).
  @@df= {} # Number of documents that have a given value (document count).
  @@f = {} # Number of times a word appears in a given document (term count).
  @@wc = {} # Number of words in a given document (word count).
  @@cw = {} # Common words to filter out.
  def self.tf_idf(entity, options={})
    l = Treat::Languages.get(entity.language)
    if l.const_defined?(:CommonWords)
      @@cw[entity.language] = l.const_get(:CommonWords)
      return 0 if @@cw[entity.language].include?(entity.value)
    end
    return 0 if entity.value.length <= 2
    options = DefaultOptions.merge(options)
    lambdas = options.partition do |k,v|
      [:tf, :idf, :normalization].include?(k)
    end[0]
    lambdas.each do |opt,val|
      if opt.is_a?(Symbol)
        if Algorithms[opt][val]
          options[opt] = Algorithms[opt][val]
        else
          raise Treat::Exception,
          "The specified algorithm '#{val}' "+
          "to calculate #{opt} does not exist."
        end
      end
    end
    collection = entity.parent_collection
    document = entity.parent_document
    dc = collection.document_count
    if !collection || !document
      raise Treat::Exception,
      "Tf*Idf requires a collection with documents."
    end
    val = entity.value.downcase
    @@n[collection.id] = dc if @@n[collection.id].nil?
    @@df[collection.id] ||= {}
    if @@df[collection.id][val].nil?
      df = 0
      collection.each_document do |doc|
        @@f[doc.id] ||= {}
        if @@f[doc.id][val].nil?
          @@f[doc.id][val] =
          doc.frequency_of(val)
        end
        df += 1 if @@f[doc.id][val] > 0
      end
      @@df[collection.id][val] = df
    end
    f = @@f[document.id][entity.value].to_f
    df = @@df[collection.id][entity.value].to_f
    tf = options[:tf].call(f).to_f
    if options[:normalize_word_count]
      @@wc[document.id] ||= document.word_count
      tf /= @@wc[document.id]
    end
    n = @@n[collection.id].to_f
    idf = options[:idf].call(n, df)
    tf_idf = tf * idf
    tf_idf.abs.round(options[:precision])
  end
end
