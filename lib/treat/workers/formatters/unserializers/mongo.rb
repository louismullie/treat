module Treat::Workers::Formatters::Unserializers::Mongo

  DefaultOptions = { :recursive => true }
  require 'mongo'
  
  def self.unserialize(entity, options={})

    options = DefaultOptions.merge(options)
    
    supertype =  cl(Treat::Entities.const_get(
    entity.type.to_s.capitalize.intern).superclass).downcase
    supertype = entity.type.to_s if supertype == 'entity'
    supertypes = supertype + 's'
    
    if !Treat.databases.mongo.db && !options[:db]
      raise Treat::Exception,
      'Must supply the database name in config. ' +
      '(Treat.databases.mongo.db = ...) or pass ' +
      'it as a parameter to #unserialize.'
    end
    
    @@database ||= Mongo::Connection.
    new(Treat.databases.mongo.host).
    db(Treat.databases.mongo.db || options[:db])

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
    
    if options[:recursive]
      record['children'].each do |c|
        cid, ctype = *c
        cklass = Treat::Entities.const_get(
        ctype.capitalize.intern)
        e = self.unserialize(cklass.new('', cid), options)
        entity << e
      end
    end

    entity

  end

end
