# Stores an entity in a Mongo collection.
class Treat::Formatters::Serializers::Mongo

  # Reauire the Mongo DB
  require 'mongo'

  DefaultOptions = {
    :recursive => true
  }
  
  def self.serialize(entity, options = {})
    
    options = DefaultOptions.merge(options)
    
    unless options[:db]
      raise Treat::Exception,
      'Must supply the database name.'
    end
    
    type = entity.type.to_s
    types = (type == 'entity') ? 'entities' : (type + 's')
    
    coll = Treat::Databases.connection(:mongo).collection(types)
    
    entity_token = {
      :id => entity.id,
      :value => entity.value,
      :type => entity.type,
      :children => entity.children.map { |c| c.id },
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


