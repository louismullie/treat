require 'yaml'
require 'set'

class Class
  def persist
    @persist = [] if !@persist
    @persist
  end
  
  def persist= p
    @persist = p if p.kind_of?(Array)
  end
  
  def persist_with_parent
    p = []
    klass = self;
    while klass
      p.concat(klass.persist)
      klass = klass.superclass
    end
    p.uniq
  end
end

class Object
  def self.persistent *var
    for i in (0..var.length-1)
      var[i] = var[i].to_s
    end
    self.persist.concat(var)
    self.persist.uniq!    
  end
  
  alias_method :old_to_yaml, :to_yaml
  
  def to_yaml ( opts = {} )       
    p = self.class.persist_with_parent

    if p && p.size > 0
      yaml_emit opts do |map|
        p.each do |m|
          map.add( m, instance_variable_get( '@' + m ) )
        end
      end
    else
      old_to_yaml opts
    end
  end
private
  def yaml_emit opts
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        yield map
      end
    end
  end
end

module RHNH
  module EnumerablePostDeserializeHelper
    def post_deserialize
      self.each do |e|
        YAML.call_post_deserialize(e) if e
      end
    end
  end
end

class Array
  include RHNH::EnumerablePostDeserializeHelper
end

class Hash
  include RHNH::EnumerablePostDeserializeHelper
end


module YAML
  def YAML.call_post_deserialize obj, object_map = ::Set.new
    if !object_map.include?(obj.object_id)
      object_map.add(obj.object_id)
      
      obj.instance_variables.each do |v|
        call_post_deserialize obj.instance_variable_get(v), object_map
      end

      obj.post_deserialize if obj.respond_to?('post_deserialize')
    end
  end
  
  def YAML.load( io )
		yp = parser.load( io )
		call_post_deserialize yp
		yp
	end
end