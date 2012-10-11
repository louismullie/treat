# This module uses structs to represent the 
# configuration options that are stored in 
# the /config folder.
module Treat::Config
  
  # Store all the configuration in self.config
  class << self; attr_accessor :config; end

  # Setup a proxy on the main Treat module to 
  # make configuration options directly accessible.
  Treat.module_eval do
    # Handle all missing methods as conf options.
    # Instead, should dynamically define them. FIXME.
    def self.method_missing(sym, *args, &block)
      super(sym, *args, &block) if sym == :to_ary
      Treat::Config.config[sym]
    end
  end

  def self.get_path
    File.dirname(File.expand_path(
    __FILE__)).split('/')[0..-4].join('/') + '/'
  end
  
  # Main function; loads all configuration options.
  def self.configure!
    # Temporary configuration hash.
    config = { paths: {} }
    conf_dir = self.get_path + 'lib/treat/config'
    puts conf_dir
    # Iterate over each directory in the config.
    Dir[conf_dir + '/*'].each do |dir|
      name = File.basename(dir, '.*').intern
      puts name
      next if name == :config; config[name] = {}
      # Iterate over each file in the directory.
      Dir[conf_dir + "/#{name}/*.rb"].each do |file|
        key = File.basename(file, '.*').intern
        config[name][key] = eval(File.read(file))
      end
    end
    # Configure all options in Treat.paths.
    config[:paths] = self.get_paths_config
    # Get the tag alignments.
    self.gen_tag_maps!(config[:tags][:aligned])
    # Convert the hash to nested structs for perf.
    self.config = self.hash_to_struct(config)
  end

  # Turn on syntactic sugar. This means that
  # all entities and learning classes can be 
  # created in a "Python-like" syntax in the 
  # global namespace (e.g. Word('hello'), 
  # Phrase('a bird'), etc.).
  def self.sweeten!
    return if Treat.core.syntax.sweetened
    Treat.core.syntax.sweetened = true
    self.sweeten_entities
    self.sweeten_learning
  end

  # Turn off syntactic sugar. See #sweeten!
  def self.unsweeten!
    self.sweeten_entities(false)
    self.sweeten_learning(false)
  end
  
  # * Helper methods for path config * #
  
  # Get the path configuration based on the 
  # directory structure loaded into Paths.
  def self.get_paths_config
    Hash[
    # Get a list of directories in treat/
    Dir.glob(self.get_path + '*').select do |path|
      FileTest.directory?(path)
    # Map to pairs of [:name, path]
    end.map do |path|
      [File.basename(path).intern, path + '/']
    end]
  end
  
  # * Helper methods for syntactic sugar * #
  
  # Map all classes in Treat::Entities to
  # a global builder function (Entity, etc.)
  def self.sweeten_entities(on = true)
    Treat.core.entities.list.each do |type|
      next if type == :Symbol
      kname = cc(type).intern
      klass = Treat::Entities.const_get(kname)
      Object.class_eval do
        define_method(kname) do |val, opts={}|
          klass.build(val, opts)
        end if on
        remove_method(name) if !on
      end
    end
  end
  
  # Map all classes in the Learning module
  # to a global builder function (e.g. DataSet).
  def self.sweeten_learning(on = true)
    Treat::Learning.constants.each do |kname|
      Object.class_eval do
        define_method(kname) do |*args| 
          Treat::Learning.const_get(kname).new(*args)
        end if on
        remove_method(name) if !on
      end
    end
  end
  
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
  
  # * General helper methods * #
  
  # Converts a hash to nested structs.
  def self.hash_to_struct(hash)
     return hash if hash.keys.
     select { |k| !k.is_a?(Symbol) }.size > 0
     struct = Struct.new(*hash.keys).new(*hash.values)
     hash.each do |key, value|
       if value.is_a?(Hash)
         struct[key] = self.hash_to_struct(value)
       end
     end; return struct
   end
  
  # * Load all configuration ! * #
  self.configure!
  
end