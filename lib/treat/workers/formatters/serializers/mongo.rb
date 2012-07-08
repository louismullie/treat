# Stores an entity in a Mongo collection.
class Treat::Workers::Formatters::Serializers::Mongo

  # Reauire the Mongo DB
  require 'mongo'

  DefaultOptions = {
    :recursive => true,
    :stop_at => :token
  }
  
  def self.serialize(entity, options = {})
    
    options = DefaultOptions.merge(options)
    stop_at = options[:stop_at] ? 
    Treat::Entities.const_get(
    options[:stop_at].to_s.capitalize) : 
    Treat::Entities::Token
    
    if !Treat.databases.mongo.db && !options[:db]
      raise Treat::Exception,
      'Must supply the database name in config. ' +
      '(Treat.databases.mongo.db = ...) or pass ' +
      'it as a parameter to #serialize.'
    end
    
    @@database ||= Mongo::Connection.
    new(Treat.databases.mongo.host).
    db(Treat.databases.mongo.db || options[:db])
    
    type = cl(entity.class.superclass).downcase
    type = entity.type.to_s if type == 'entity'
    types = type + 's'

    coll = @@database.collection(types)
    
    entity_token = {
      :id => entity.id,
      :value => entity.value,
      :string => entity.to_s,
      :type => entity.type,
      :children => entity.children.map { |c| [c.id, c.type] },
      :parent => (entity.has_parent? ? entity.parent.id : nil),
      :features => entity.features
    }
    
    coll.insert(entity_token)

    if options[:recursive] && entity.has_children?
      entity.each do |child|
        next if child.class.compare_with(stop_at) < 0
        self.serialize(child, options)
      end
    end
     
  end

end


