module Treat::Workers::Formatters::Unserializers::Mongo
  
  require 'mongo'
  
  def self.unserialize(entity, options={})
    
    db = options.delete(:db)
    selector = options
    
    if !Treat.databases.mongo.db && !db
      raise Treat::Exception,
      'Must supply the database name in config. ' +
      '(Treat.databases.mongo.db = ...) or pass ' +
      'it as a parameter to #unserialize.'
    end
    
    @@database ||= Mongo::Connection.
    new(Treat.databases.mongo.host).
    db(Treat.databases.mongo.db || db)
    
    supertype =  cl(Treat::Entities.const_get(
    entity.type.to_s.capitalize.intern).superclass).downcase
    supertype = entity.type.to_s if supertype == 'entity'
    supertypes = supertype + 's'
    
    coll = @@database.collection(supertypes)
    records = coll.find(selector).to_a
    
    if records.size == 0
      raise Treat::Exception,
      "Couldn't find any records using " +
      "selector #{selector.inspect}."
    elsif records.size == 1
      self.do_unserialize(
      records.first, options)
    else
      matches = []
      records.each do |record|
        matches << self.
        do_unserialize(record, options)
      end
      matches
    end
    
  end

  def self.do_unserialize(record, options)
    
    entity = Treat::Entities.
    const_get(record['type'].
    capitalize.intern).new(
    record['value'], record['id'])
    
    features = record['features']
    new_feat = {}
    features.each do |feature, value|
      new_feat[feature.intern] = value
    end
    
    entity.features = new_feat
    
    record['children'].each do |c|
      entity << self.do_unserialize(c, options)
    end

    entity
    
  end
  
end
