module Treat::Formatters::Unserializers::Mongo

  DefaultOptions = { :recursive => true }

  def self.unserialize(entity, options={})

    options = DefaultOptions.merge(options)

    type = entity.type.to_s
    types = (type == 'entity') ?
    'entities' : (type + 's')

    coll = Treat::Databases.connection(:mongo).
    collection(types)

    record = coll.find(:id => entity.id.to_s)
    
    entity.features = record['features']

    if options[:recursive]
      record['children'].each do |c|
        e = self.unserialize(
        Treat::Entities::Entity.new('', id), options)
        entity << e
      end
    end

    entity

  end

end
