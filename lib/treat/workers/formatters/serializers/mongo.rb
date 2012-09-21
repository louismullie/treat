# Serialization of entities to a Mongo database.
class Treat::Workers::Formatters::Serializers::Mongo

  # Reauire the Mongo DB
  require 'mongo'

  DefaultOptions = {
    :recursive => true,
    :stop_at => nil
  }

  def self.serialize(entity, options = {})

    options = DefaultOptions.merge(options)
    options[:stop_at] = options[:stop_at] ?
    Treat::Entities.const_get(
    options[:stop_at].to_s.capitalize) : nil

    options[:db] ||= Treat.databases.mongo.db
    
    if !options[:db]
      raise Treat::Exception,
      'Must supply the database name in config. ' +
      '(Treat.databases.mongo.db = ...) or pass ' +
      'it as a parameter to #serialize.'
    end

    @@database ||= Mongo::Connection.
    new(Treat.databases.mongo.host).
    db(options[:db])

    supertype =  cl(Treat::Entities.const_get(
    entity.type.to_s.capitalize.intern).superclass).downcase
    supertype = entity.type.to_s if supertype == 'entity'
    supertypes = supertype + 's'
    
    coll = @@database.collection(supertypes)
    
    if entity.type == :collection
      docs = @@database.collection('documents')                    # Take a design decision here.
      coll.update(
        {id: entity.id}, self.do_serialize(entity, 
        options.merge({:stop_at => Treat::Entities::Document})), 
        {upsert: true})
      entity.each_document do |doc|
        docs.update(
        {id: doc.id}, self.do_serialize(doc, options), 
        {upsert: true})
      end
    else
      entity_token = self.do_serialize(entity, options)
      coll.update({id: entity.id}, entity_token, {upsert: true})
    end
    
    {db: options[:db], collection: supertypes, id: entity.id}
    
  end

  def self.do_serialize(entity, options)

    children = []

    if options[:recursive] && entity.has_children?
      entity.each do |child|
        next if options[:stop_at] && child.class.
        compare_with(options[:stop_at]) < 0
        children << self.do_serialize(child, options)
      end
    end

    entity_token = {
      :id => entity.id,
      :value => entity.value,
      :type => entity.type.to_s,
      :children => children,
      :parent => (entity.has_parent? ? entity.parent.id : nil),
      :features => entity.features
    }

    entity_token

  end

end
