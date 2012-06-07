module Treat::Databases
  
  @@connections = {}
  
  def self.connect(type, host = 'localhost', pt = nil, un = nil, pw = nil)

    conn = nil
    
    if type == :mongo
      require 'mongoid'
      conn = Mongoid.configure do |config|
          name = "treat"
          host = "localhost"
          config.master = Mongo::Connection.new.db(name)
      end
    end
    
    @@connections[type] = conn
    
  end
  
  def self.connection(type)
    @@connections[type]
  end

  
end