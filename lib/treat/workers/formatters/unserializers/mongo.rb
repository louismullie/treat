module Treat::Workers::Formatters::Unserializers::Mongo

  DefaultOptions = { 
    :recursive => true,
    :stop_at => nil
  }
  
  require 'mongo'
  
  def self.unserialize(entity, options={})

    options = DefaultOptions.merge(options)
    options[:stop_at] = options[:stop_at] ? 
    Treat::Entities.const_get(
    options[:stop_at].to_s.capitalize) : 
    Treat::Entities::Token
    
    if !Treat.databases.mongo.db && !options[:db]
      raise Treat::Exception,
      'Must supply the database name in config. ' +
      '(Treat.databases.mongo.db = ...) or pass ' +
      'it as a parameter to #unserialize.'
    end
    
    @@database ||= Mongo::Connection.
    new(Treat.databases.mongo.host).
    db(Treat.databases.mongo.db || options[:db])

    self.do_unserialize(entity, options)
    
  end

  def self.do_unserialize(entity, options)
    
    supertype =  cl(Treat::Entities.const_get(
    entity.type.to_s.capitalize.intern).superclass).downcase
    supertype = entity.type.to_s if supertype == 'entity'
    supertypes = supertype + 's'
    
    coll = @@database.collection(supertypes)
    record = coll.find_one(:id => entity.id)

    unless record
      raise Treat::Exception,
      "Couldn't find record ID #{entity.id}."
    end
    
    # Convert feature keys to symbols.
    features = record['features']
    new_feat = {}
    features.each do |feature, value|
      new_feat[feature.intern] = value
    end
    entity.features = new_feat
    
    # Set the entity's value.
    entity.value = record['value']
    
    if entity.class.compare_with(
      options[:stop_at]) == 0
      entity.value = record['string']
    end
    
    return entity unless options[:recursive]

    record['children'].each do |c|
      cid, ctype = *c
      cklass = Treat::Entities.const_get(
      ctype.capitalize.intern)
      next if cklass.compare_with(
      options[:stop_at]) < 0
      entity << self.do_unserialize(
      cklass.new('', cid), options)
    end

    entity
    
  end
  
end
