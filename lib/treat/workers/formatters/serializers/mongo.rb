# Stores an entity in a Mongo collection.
class Treat::Workers::Formatters::Serializers::Mongo

  # Reauire the Mongo DB
  require 'mongo'

  DefaultOptions = {
    :recursive => true
  }
  
  def self.serialize(entity, options = {})
    
    options = DefaultOptions.merge(options)

    if !Treat.databases.mongo.db && !options[:db]
      raise Treat::Exception,
      'Must supply the database name in config. ' +
      '(Treat.databases.mongo.db = ...) or pass ' +
      'it as a parameter to #serialize.'
    end
    
    @@database ||= Mongo::Connection.
    new(Treat.databases.mongo.host).
    db(Treat.databases.mongo.db || options[:db])
    
    type = entity.type.to_s
    types = (type == 'entity') ? 'entities' : (type + 's')
    
    coll = @@database.collection(types)
    
    entity_token = {
      :id => entity.id,
      :value => entity.value,
      :type => entity.type,
      :children => entity.children.map { |c| [c.id, c.type] },
      :parent => (entity.has_parent? ? entity.parent.id : nil),
      :features => entity.features
    }
    
    coll.insert(entity_token)

    if options[:recursive] && entity.has_children?
      entity.each do |child|
        self.serialize(child, options)
      end
    end
     
  end

end


