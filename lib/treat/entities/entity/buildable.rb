# Represents an object that can be built
# from a folder of files, a specific file,
# a string or a numeric object. This class
# is pretty much self-explanatory.
# FIXME how can we make this language independent?
module Treat::Entities::Entity::Buildable

  require 'schiphol'
  require 'fileutils'
  require 'uri'

  # Simple regexps to match common entities.
  WordRegexp = /^[[:alpha:]\-']+$/
  NumberRegexp = /^#?([0-9]+)(\.[0-9]+)?$/
  PunctRegexp = /^[[:punct:]\$]+$/
  UriRegexp = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  EmailRegexp = /.+\@.+\..+/
  Enclitics = %w['ll 'm 're 's 't 've 'nt]

  # Reserved folder names
  Reserved = ['.index']

  # Build an entity from anything (can be
  # a string, numeric,folder, or file name
  # representing a raw or serialized file).
  def build(*args)
    
    # This probably needs some doc.
    if args.size == 0
      file_or_value = ''
    elsif args[0].is_a?(Hash)
      file_or_value = args[0]
    elsif args.size == 1
      if args[0].is_a?(Treat::Entities::Entity)
        args[0] = [args[0]]
      end
      file_or_value = args[0]
    else
      file_or_value = args
    end

    fv = file_or_value.to_s

    if fv == ''; self.new
    elsif file_or_value.is_a?(Array)
      from_array(file_or_value)
    elsif file_or_value.is_a?(Hash)
      from_db(file_or_value)
    elsif self == Treat::Entities::Document ||
      (fv.index('.yml') || fv.index('.yaml') ||
      fv.index('.xml'))
      if fv =~ UriRegexp
        from_url(fv)
      else
        from_file(fv)
      end
    elsif self == Treat::Entities::Collection
      if FileTest.directory?(fv)
        from_folder(fv)
      else
        create_collection(fv)
      end
    else
      if file_or_value.is_a?(String)
        from_string(file_or_value)
      elsif file_or_value.is_a?(Numeric)
        from_numeric(file_or_value)
      else
        raise Treat::Exception,
        "Unrecognizable input '#{fv}'. "+
        "Please supply a folder, " +
        "filename, string or number."
      end
    end

  end

  # Build an entity from a string. Type is
  # enforced only if requested or if the entity
  # is user-created (i.e. by calling build
  # instead of from_string directly).
  def from_string(string, enforce_type = false)
    # If calling using the build syntax (i.e. user-
    # called), enforce the type that was supplied.
    enforce_type = true if caller_method == :build
    unless self == Treat::Entities::Entity
      return self.new(string) if enforce_type
    end
    e = anything_from_string(string)
    if enforce_type && !e.is_a?(self)
      raise "Asked to build a #{self.mn.downcase} "+
      "from \"#{string}\" and to enforce type, "+
      "but type detected was #{e.class.mn.downcase}."
    end
    e
  end
  
  # Build a document from an array
  # of builders.
  def from_array(array)
    obj = self.new
    array.each do |el|
      el = el.to_entity unless el.is_a?(Treat::Entities::Entity)
      obj << el
    end
    obj
  end

  # Build a document from an URL.
  def from_url(url)
    unless self ==
      Treat::Entities::Document
      raise Treat::Exception,
      'Cannot create something ' +
      'else than a document from a url.'
    end

    begin
      folder = Treat.paths.files
      if folder[-1] == '/'
        folder = folder[0..-2] 
      end
      f = Schiphol.download(url,
      download_folder: folder,
      show_progress: !Treat.core.verbosity.silence,
      rectify_extensions: true,
      max_tries: 3)
    rescue
      raise Treat::Exception,
      "Couldn't download file at #{url}."
    end

    e = from_file(f,'html')
    e.set :url, url.to_s
    e

  end

  # Build an entity from a Numeric object.
  def from_numeric(numeric)
    unless (self ==
      Treat::Entities::Number) ||
      (self == Treat::Entities::Token) ||
      (self == Treat::Entities::Entity)
      raise Treat::Exception,
      "Cannot create something " +
      "else than a number/token from " +
      "a numeric object."
    end
    n = numeric.to_s
    Treat::Entities::Number.new(n)
  end

  # Build an entity from a folder with documents.
  # Folders will be searched recursively.
  def from_folder(folder)

    return if Reserved.include?(folder)

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
    
    if !FileTest.directory?(folder)
      FileUtils.mkdir(folder)
    end
    
    c.set :folder, folder
    i = folder + '/.index'
    c.set :index, i if FileTest.directory?(i)
    
    Dir[folder + '*'].each do |f|
      if FileTest.directory?(f)
        c2 = Treat::Entities::Collection.
        from_folder(f)
        c.<<(c2, false) if c2
      else
        c.<<(Treat::Entities::Document.
        from_file(f), false)
      end
    end
    
    return c

  end

  # Build a document from a raw or serialized file.
  def from_file(file,def_fmt=nil)

    if file.index('.yml') ||
      file.index('.yaml') ||
      file.index('.xml')
      from_serialized_file(file)
    else
      fmt = Treat::Workers::Formatters::Readers::Autoselect.detect_format(file,def_fmt)
      from_raw_file(file, fmt)
    end

  end

  # Build a document from a raw file.
  def from_raw_file(file, def_fmt='txt')

    unless self ==
      Treat::Entities::Document
      raise Treat::Exception,
      "Cannot create something else than a " +
      "document from raw file '#{file}'."
    end

    unless File.readable?(file)
      raise Treat::Exception,
      "Path '#{file}' does not "+
      "point to a readable file."
    end
    options =  {default_format: def_fmt}
    d = Treat::Entities::Document.new
    d.set :file, file
    d.read(:autoselect, options)

  end

  # Build an entity from a serialized file.
  def from_serialized_file(file)
    
    unless File.readable?(file)
      raise Treat::Exception,
      "Path '#{file}' does not "+
      "point to a readable file."
    end
    doc = Treat::Entities::Document.new
    doc.set :file, file
    format = nil
    if file.index('yml') || 
      file.index('yaml')
      format = :yaml
    elsif file.index('xml')
      f = :xml
    else
      raise Treat::Exception,
      "Unreadable serialized format for #{file}."
    end
    doc.unserialize(format)
    doc.children[0].set_as_root!              # Fix this
    doc.children[0]

  end

  def from_db(hash)
    adapter = (hash.delete(:adapter) ||
    Treat.databases.default.adapter)
    unless adapter
      raise Treat::Exception,
      "You must supply which database " +
      "adapter to use by passing the :adapter " +
      "option or setting configuration option" +
      "Treat.databases.default.adapter"
    end
    self.new.unserialize(adapter, hash)
  end

  # Build any kind of entity from a string.
  def anything_from_string(string)
    case self.mn.downcase.intern
    when :document
      folder = Treat.paths.files
      if folder[-1] == '/'
        folder = folder[0..-2]
      end
      
      now = Time.now.to_f
      doc_file = folder+ "/#{now}.txt"
      string.force_encoding('UTF-8')
      File.open(doc_file, 'w') do |f|
        f.puts string
      end

      from_raw_file(doc_file)
    when :collection
      raise Treat::Exception,
      "Cannot create a " +
      "collection from a string " +
      "(need a readable file/folder)."
    when :phrase
      group_from_string(string)
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
          group_from_string(string)
        else
          zone_from_string(string)
        end
      end
    else
      self.new(string)
    end

  end

  # This should be improved on.
  def check_encoding(string)
    string.encode("UTF-8", undef: :replace) # Fix
  end

  # Build a phrase from a string.
  def group_from_string(string)
    check_encoding(string)
    if !(string =~ /[a-zA-Z]+/)
      Treat::Entities::Fragment.new(string)
    elsif string.count('.!?') >= 1
      Treat::Entities::Sentence.new(string)
    else
      Treat::Entities::Phrase.new(string)
    end
  end

  # Build the right type of token
  # corresponding to a string.
  def token_from_string(string)

    check_encoding(string)
    if Enclitics.include?(string.downcase)
      Treat::Entities::Enclitic.new(string)
    elsif string =~ WordRegexp &&
      string.count(' ') == 0 &&
      string != '-'
      Treat::Entities::Word.new(string)
    elsif string =~ NumberRegexp
      from_numeric(string)
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

    check_encoding(string)
    dot = string.count('.!?')
    if dot && dot >= 1 && string.count("\n") > 0
      Treat::Entities::Section.new(string)
    elsif string.count('.') == 0 &&
      string.size < 45
      Treat::Entities::Title.new(string)
    else
      Treat::Entities::Paragraph.new(string)
    end

  end
  
  def create_collection(fv)
    FileUtils.mkdir(fv)
    Treat::Entities::Collection.new(fv)
  end


end
