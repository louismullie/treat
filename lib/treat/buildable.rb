module Treat
  # Represents an object that can be built
  # from a folder of files, a specific file,
  # a string or a numeric object. This class
  # is pretty much self-explanatory.
  module Buildable
    # Initialize the document with its filename.
    # Optionally specify a reader to read the file.
    # If +read+ is set to false, the document will
    # not be read automatically; in that case, the
    # method #read must be called on the document
    # object to load it in.
    def build(file_or_value = '', id = nil)
      from_anything(file_or_value, id)
    end
    def from_anything(file_or_value, id)
      if File.readable?(file_or_value.to_s)
        from_file(file_or_value)
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
    def from_string(string, enforce_type = false)
      enforce_type = true if caller_method == :build
      if self == Treat::Entities::Document ||
        self == Treat::Entities::Collection
        raise Treat::Exception,
        "Cannot create a document or collection from " +
        "a string (need a readable file/folder)."
      end
      unless self == Treat::Entities::Entity
        return self.new(string) if enforce_type 
      end
      dot = string.count('.!?')
      if self == Treat::Entities::Phrase
        if dot >= 1
          c = Treat::Entities::Sentence.new(string)
        else
          c = Treat::Entities::Phrase.new(string)
        end
      elsif (self == Treat::Entities::Token) || 
        string.count(' ') == 0
        if string == "'s"
          c = Treat::Entities::Clitic.new(string) 
        elsif string =~ /^[[:alpha:]\-']+$/ && 
              string.count(' ') == 0
          c = Treat::Entities::Word.new(string) 
        elsif string =~ /^[[:digit:]]+$/
          c = Treat::Entities::Number.new(string) 
        elsif string =~ /^[[:punct:]]+$/
          c = Treat::Entities::Punctuation.new(string)
        else
          c = Treat::Entities::Symbol.new(string)
        end
      elsif dot > 1 || string.count("\n") > 0
        c = Treat::Entities::Section.new(string) 
      elsif dot >= 1 && dot < 5 && string.size > 5
        c = Treat::Entities::Sentence.new(string) 
      elsif string.strip.count(' ') > 0
        c = Treat::Entities::Phrase.new(string)
      else
        c = Treat::Entities::Unknown.new(string) unless c
      end
      unless self == c.class || self == Treat::Entities::Entity || c.is_a?(self)
        raise "You said that \"#{string}\" was a #{cl(self).downcase}, " +
             "but Treat thinks it is a #{cl(c.class).downcase}."
      end
      c
    end
    def from_numeric(numeric)
      unless self == Treat::Entities::Number
        raise Treat::Exception,
        "Cannot create something else than a " +
        " number from a numeric object."
      end
      Treat::Entities::Number.new(numeric.to_s)
    end
    def from_folder(folder, exclude = ['cfs'])
      unless FileTest.directory?(folder)
        raise Treat::Exception,
        "Path '#{folder}' does not point to a folder."
      end
      unless File.readable?(folder)
        raise Treat::Exception,
        "Folder '#{folder}' is not readable."
      end
      unless self == Treat::Entities::Collection
        raise Treat::Exception,
        "Cannot create something else than a " +
        "collection from folder '#{folder}'."
      end
      c = Treat::Entities::Collection.new(folder)
      folder += '/' unless folder[-1] == '/'
      Dir[folder + '*'].each do |f|
        if FileTest.directory?(f)
          c2 = Treat::Entities::Collection.from_folder(f)
          c << c2
        else
          c << Treat::Entities::Document.from_file(f)
        end
      end
      c
    end
    def from_file(file)
      unless File.readable?(file)
        raise Treat::Exception,
        "Path '#{file}' does not point to a readable file."
      end
      if FileTest.directory?(file)
        from_folder(file)
      else
        ext = file.split('.')[-1]
        # Humanize the yaml extension.
        ext = 'yaml' if ext == 'yml'
        if ext == 'yaml'
          from_serialized_file(file)
        elsif ext == 'xml'
          beginning = nil
          File.open(file) do |w| 
            beginning = w.readlines(200) 
          end
          beginning = beginning.join(' ')
          if beginning.index('<treat>')
            from_serialized_file(file)
          else
            from_raw_file(file)
          end
        elsif ext == 'cfs'
          return
        else
          from_raw_file(file)
        end
      end
    end
    def from_raw_file(file)
      unless self == Treat::Entities::Document
        raise Treat::Exception,
        "Cannot create something else than a " +
        "document from raw file '#{file}'."
      end
      d = Treat::Entities::Document.new(file)
      d.read
    end
    def from_serialized_file(file)
      d = Treat::Entities::Document.new(file)
      d.unserialize
      d.children[0].set_as_root!
      d.children[0]
    end
  end
end
