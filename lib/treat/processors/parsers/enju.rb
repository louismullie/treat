# This class is a wrapper for the Enju syntactic
# parser for English. Given an entity's string value,
# the parser formats it runs it through Enju, and
# parses the XML output by Enju using the Nokogiri
# XML reader. It creates wrappers for the sentences,
# syntactical phrases and tokens that Enju identified.
#
# Original paper:
#
# Takuya Matsuzaki, Yusuke Miyao, and Jun'ichi Tsujii.
# 2007. Efficient HPSG Parsing with Supertagging and
# CFG-filtering. In Proceedings of IJCAI 2007.
module Treat::Processors::Parsers::Enju

  # Require the 'open3' library to connect
  # with the background Enju process.
  require 'open3'
  
  # Require the Nokogiri XML parser.
  require 'nokogiri'
  
  # Create only one process and hold on to it.
  @@parser = nil
  
  # A hash of Enju cat tags mapped to word categories.
  Ectc = Treat::Languages::Tags::EnjuCatToCategory
  
  # A hash of Enju cat/xcat pairs mapped to PTB tags.
  Ecxtp = Treat::Languages::Tags::EnjuCatXcatToPTB
  
  # Parse the entity into its syntactical 
  # phrases using Enju.
  #
  # Options: none.
  def self.parse(entity, options = {})
    
    entity.check_hasnt_children
    val = entity.to_s
    
    @@id_table = {}
    @@dependencies_table = {}
    
    stdin, stdout = proc
    text, remove_last = valid_text(val)
    stdin.puts(text + "\n")
    
    parsed = build(stdout.gets, remove_last)
    
    if parsed
      entity.remove_all!
      parsed.children.each do |child|
        entity << child
      end
      # Remove the period we added at the end.
      if remove_last
        last = entity.punctuations[-1]
        entity.remove!(last)
      end
    else
      warn "Warning - Enju couldn't " +
      "parse the text '#{entity.short_value}'."
      return
    end
    
    link_heads(entity)
    add_dependencies(entity)
  end
  
  # Return the process running Enju.
  def self.proc
    begin
      @@parser = ::Open3.popen3("enju -xml -i")
    rescue Exception => e
      raise Treat::Exception,
      "Couldn't initialize Enju: #{e.message}."
    end
    @@parser
  end
  
  # Parses an Enju XML output file using the Nogoriki
  # XML reader and converts that structure into a tree
  # of wrappers for textual entities.
  def self.build(xml, remove_last = false)
    # Read in the XML file.
    reader = Nokogiri::XML::Reader.from_memory(xml)
    entity = nil
    pd = 0
    # Read the XML file entity by entity.
    while reader.read
      # The depth in the XML tree.
      cd = reader.depth
      # If we are at the end of the 
      # children stack, pop up.
      if pd > cd
        entity = entity.parent
      end
      # If an end element has been reached,
      # change the depth and pop up on next
      # iteration.
      if reader.node_type ==
        Nokogiri::XML::Reader::TYPE_END_ELEMENT
        pd = cd
        next
      end
      # Get and format attributes and dependencies.
      attributes = reader.attributes
      id = attributes.delete('id')
      new_attr = {}; dependencies = {}
      unless attributes.size == 0
        new_attr, dependencies =
        cleanup_attributes(reader.name, attributes)
      end
      # Create the appropriate entity for the
      # element.
      current_value = ''
      case reader.name
      when 'sentence'
        entity = Treat::Entities::Sentence.new('')
        @@id_table[id] = entity.id
        @@dependencies_table[entity.id] = dependencies
        entity.features = new_attr
      when 'cons'
        entity = entity <<
        Treat::Entities::Phrase.new('')
        @@id_table[id] = entity.id
        @@dependencies_table[entity.id] = dependencies
        entity.features = new_attr
      when 'tok'
        tmp_attributes = new_attr
        tmp_dependencies = dependencies
      else
        current_value = reader.value.gsub(/\s+/, "")
        unless current_value.size == 0
          entity = entity <<
          Treat::Entities::Token.from_string(current_value)
          if entity.is_a?(Treat::Entities::Word)
            entity.features = tmp_attributes
            @@id_table[id] = entity.id
            @@dependencies_table[entity.id] = tmp_dependencies
          else
            # Do something useful here
            entity.set :tag, 'SYM'
          end
        end
      end
      pd = cd
    end
    entity
  end
  
  # Validate a text - Enju wants period to parse a sentence.
  def self.valid_text(val)
    if val.count('.') == 0
      remove_last = true
      text = val + '.'
    else
      remove_last = false
      text = val.gsub('.', '')
      text += '.' unless ['!', '?'].include?(text[-1])
    end
    return text, remove_last
  end
  
  # Link the head and sem_head to their entities.
  def self.link_heads(entity)
    entity.each_phrase do |phrase|
      if phrase.has?(:head)
        phrase.link(
        @@id_table[phrase.head], 
        'head', true, -1)
        phrase.unset(:head)
      end
      if phrase.has?(:sem_head)
        phrase.link(
        @@id_table[phrase.sem_head], 
        'sem_head', true, -1)
        phrase.unset(:sem_head)
      end
    end
  end
  
  # Add dependencies a posteriori to a parsed entity.
  def self.add_dependencies(entity2)
    
    entity2.each_entity(:word, :phrase) do |entity|
      @@dependencies_table.each_pair do |id, dependencies|
        next if dependencies.nil?
        entity = entity2.root.find(id)
        next if entity.nil?
        dependencies.each_pair do |argument, type|
          # Skip this argument if we 
          # don't know the target node.
          next if argument == 'unk'
          entity.link(
            @@id_table[argument], 
            type.intern
          )
        end
      end
    end
    
  end
  
  # Helper function to convert Enju attributes to Treat attributes.
  def self.cleanup_attributes(name, attributes)
    
    new_attr = {}
    dependencies = {}
    pred = attributes.delete('pred')
    
    attributes.each_pair do |attribute2, value|
      
      attribute = attribute2.strip
      
      if attribute == 'arg1' || 
        attribute == 'arg2'
        dependencies[value] = pred
        next
      end
      
      if attribute == 'cat'
        new_attr[:cat] = value
        if name == 'tok'
          if value.length > 1 && 
            ['P', 'X'].include?(value[-1]) &&
            value != 'PN'
            new_attr[:saturated] = 
            (value[-1] == 'P')
            value = value[0..-2]
          end
          new_attr[:category] = Ectc[value]
        else
          tags = Ecxtp.select do |m|
            m[0] == value && m[1] == 
            attributes['xcat']
          end
          tag = (tags.size == 0) ? 
          'FW' : tags[0][2]
          new_attr[:tag] = tag
        end
      else
        new_attr[:"#{attribute}"] = value
      end
      
    end
    
    # Handle naming conventions.
    if attributes.has_key?('pos')
      new_attr[:tag] = new_attr[:pos]
      new_attr[:tag_set] = :penn
      new_attr.delete :pos
    end
    
    if attributes.has_key?('base')
      new_attr[:lemma] = new_attr[:base]
      new_attr.delete :base
    end
    
    return new_attr, dependencies
  
  end
  
end