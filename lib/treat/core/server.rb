class Treat::Core::Server 
  
  # Refer to http://rack.rubyforge.org/doc/classes/Rack/Server.html
  # for possible options to configure.
  def initialize(handler = 'thin', options = {})
    require 'json'; require 'rack'
    @handler, @options = handler.capitalize, options
  end
  
  def start
    handler = Rack::Handler.const_get(@handler)
    handler.run(self, @options)
  end
  
  def call(env)
    headers = { 'content-type' => 'application/json' }
    rack_input = env["rack.input"].read
    if rack_input.strip == ''
      return [500, headers, {
        'error' => 'Empty JSON request.'
      }]
    end
    rack_json = JSON.parse(rack_input)
    unless rack_json['type'] && 
    rack_json['value'] && rack_json['do']
      return [500, headers, {
        'error' => 'Must specify "type", "value" and "do".'
      }]
    end
    if rack_json['conf']
      # Set the configuration.
    end
    method = rack_json['type'].capitalize.intern
    resp = send(method, rack_json[value]).do(rack_json['do'])
    
    response = [rack_input.to_json]
    [200, headers, response]
  end
  
end