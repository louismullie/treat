module Treat
  # Represents an object that can be built
  # from a folder of files, a specific file,
  # a string or a numeric object. This class
  # is pretty much self-explanatory.
  module Buildable
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
    def from_string(string)
      if self == Treat::Entities::Document ||
        self == Treat::Entities::Collection
        raise Treat::Exception,
        "Cannot create a document or collection from " +
        "a string (need a readable file/folder)."
      end
      dot = string.count('.') + string.count('!') + string.count('?')
      return Treat::Entities::Section.new(string) if dot > 1 ||
      (string.count("\n") > 0 && dot == 1)
      return Treat::Entities::Sentence.new(string) if dot == 1 && string.size > 5
      if string.count(' ') == 0
        return Treat::Entities::Clitic.new(string) if string == "'s"
        return Treat::Entities::Word.new(string) if string =~ /^[[:alpha:]\-']+$/
        return Treat::Entities::Number.new(string) if string =~ /^[[:digit:]]+$/
        return Treat::Entities::Punctuation.new(string) if string =~ /^[[:punct:]]+$/
        return Treat::Entities::Symbol.new(string)
      else
        return Treat::Entities::Phrase.new(string)
      end
      return Treat::Entities::Unknown.new(string)
    end
    def from_numeric(numeric)
      unless self == Treat::Entities::Number
        raise Treat::Exception,
        "Cannot create something else than a " +
        " number from a numeric object."
      end
      Treat::Entities::Number.new(numeric.to_s)
    end
    def from_folder(folder)
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
      c = Treat::Entities::Collection.new
      folder += '/' unless folder[-1] == '/'
      Dir[folder + '*'].each do |f|
        next if FileTest.directory?(f)
        c << Treat::Entities::Document.from_file(f)
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
        if Treat::Formatters::Unserializers.list.
          include?(ext.downcase.intern)
          from_serialized_file(file)
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
