module Treat::Config::Databases
  Options = {
    default: {adapter: :mongo},
    mongo: {host: 'localhost', port: '27017', db: nil }
  }
end