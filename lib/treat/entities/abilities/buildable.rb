# Represents an object that can be built
# from a folder of files, a specific file,
# a string or a numeric object. This class
# is pretty much self-explanatory.
module Treat::Entities::Abilities::Buildable

  WordRegexp = /^[[:alpha:]\-']+$/
  NumberRegexp = /^[[:digit:]]+$/
  PunctRegexp = /^[[:punct:]]+$/
  UriRegexp = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  EmailRegexp = /.+\@.+\..+/
  
  # Build an entity from anything (can be
  # a string, numeric,folder, or file name
  # representing a raw or serialized file).
  def build(file_or_value, options = {})

    fv = file_or_value.to_s

    if File.readable?(fv)
      if FileTest.directory?(fv)
        from_folder(file_or_value, options)
      else
        from_file(file_or_value, options)
      end
    elsif file_or_value.is_a?(String)
      from_string(file_or_value)
    elsif file_or_value.is_a?(Numeric)
      from_numeric(file_or_value)
    else
      raise Treat::Exception,
      "Unrecognizable input #{file_or_value}. "+
      "Use filename, folder, text or a number."
    end

  end

  # Build an entity from a string. Type is 
  # enforced only if requested or if the entity 
  # is user-created (i.e. by calling build 
  # instead of from_string directly).
  def from_string(string, enforce_type = false)
    enforce_type = true if caller_method == :build
    
    unless self == Treat::Entities::Entity
      return self.new(string) if enforce_type
    end

    e = anything_from_string(string)

    if enforce_type && !e.is_a?(self)
      raise "Asked to build a #{cl(self).downcase} "+
      "from \"#{string}\" and to enforce type, "+
      "but type detected was #{cl(e.class).downcase}."
    end
    
    e
  end

  # Build an entity from a Numeric object.
  def from_numeric(numeric)
    unless self ==
      Treat::Entities::Number
      raise Treat::Exception,
      "Cannot create something " +
      "else than a number from " +
      "a numeric object."
    end
    Treat::Entities::Number.new(numeric.to_s)
  end

  # Build an entity from a folder with documents.
  # Folders will be searched recursively.
  def from_folder(folder, options)
    unless FileTest.directory?(folder)
      raise Treat::Exception,
      "Path '#{folder}' does " +
      "not point to a folder."
    end

    unless File.readable?(folder)
      raise Treat::Exception,
      "Folder '#{folder}' is not readable."
    end

    unless self ==
      Treat::Entities::Collection
      raise Treat::Exception,
      "Cannot create something " +
      "else than a collection " +
      "from folder '#{folder}'."
    end

    c = Treat::Entities::Collection.new(folder)
    folder += '/' unless folder[-1] == '/'

    Dir[Treat.lib + folder + '*'].each do |f|
      if FileTest.directory?(f)
        c2 = Treat::Entities::Collection.
        from_folder(f, options)
        c << c2
      else
        c << Treat::Entities::Document.
        from_file(f, options)
      end
    end

    c
  end

  # Build a document from a raw or serialized file.
  def from_file(file, options)
    unless File.readable?(file)
      raise Treat::Exception,
      "Path '#{file}' does not "+
      "point to a readable file."
    end

    ext = file.split('.')[-1]
    # Humanize the yaml extension.
    ext = 'yaml' if ext == 'yml'
    if ext == 'yaml'
      from_serialized_file(file, options)
    elsif ext == 'xml'
      beginning = nil
      File.open(file) do |w|
        beginning = w.readlines(200)
      end
      beginning = beginning.join(' ')
      if beginning.index('<treat>')
        from_serialized_file(file)
      else
        from_raw_file(file, options)
      end
    else
      from_raw_file(file, options)
    end
  end

  # Build a document from a raw file.
  def from_raw_file(file, options)
    unless self == 
      Treat::Entities::Document
      raise Treat::Exception,
      "Cannot create something else than a " +
      "document from raw file '#{file}'."
    end
    d = Treat::Entities::Document.new(file)
    d.read(:autoselect, options)
  end

  # Build an entity from a serialized file.
  def from_serialized_file(file)
    d = Treat::Entities::Document.new(file)
    d.unserialize(:autoselect, options)
    d.children[0].set_as_root!
    d.children[0]
  end

  # Build any kind of entity from a string.
  def anything_from_string(string)
    case cl(self).downcase.intern
    when :document, :collection
      raise Treat::Exception,
      "Cannot create a document or " +
      "collection from a string " +
      "(need a readable file/folder)."
    when :phrase
      phrase_from_string(string)
    when :token
      token_from_string(string)
    when :zone
      zone_from_string(string)
    when :entity
      if string.count(' ') == 0
        token_from_string(string)
      else
        if string.gsub(/[\.\!\?]+/,
          '.').count('.') <= 1 &&
          string.count("\n") == 0
          phrase_from_string(string)
        else
          zone_from_string(string)
        end
      end
    else
      self.new(string)
    end
  end

  # Build a phrase from a string.
  def phrase_from_string(string)
    if string.count('.!?') >= 1
      Treat::Entities::Sentence.new(string)
    else
      Treat::Entities::Phrase.new(string)
    end
  end

  # Build the right type of token
  # corresponding to a string.
  def token_from_string(string)
    if string == "'s" || string == "'S"
      Treat::Entities::Clitic.new(string)
    elsif string =~ WordRegexp &&
      string.count(' ') == 0 &&
      string != '-'
      Treat::Entities::Word.new(string)
    elsif string =~ NumberRegexp
      Treat::Entities::Number.new(string)
    elsif string =~ PunctRegexp
      Treat::Entities::Punctuation.new(string)
    elsif string.count('.') > 0 && 
      string =~ UriRegexp
      Treat::Entities::Url.new(string)
    elsif string.count('@') > 0 && 
      string =~ EmailRegexp
      Treat::Entities::Email.new(string)
    else
      Treat::Entities::Symbol.new(string)
    end
  end

  # Build the right type of zone 
  # corresponding to the string.
  def zone_from_string(string)
    dot = string.count('.!?')
    if dot >= 1 && string.count("\n") > 0
      Treat::Entities::Section.new(string)
    elsif string.count('.') == 0 && 
          string.size < 60
      Treat::Entities::Title.new(string)
    else
      Treat::Entities::Paragraph.new(string)
    end
  end

end
