module Treat
  
  # Require custom exception cass.
  require 'treat/exception'

  # Treat requires Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise Treat::Exception,
    'Treat requires Ruby 1.9 or higher.'
  end

  # The current version of Treat.
  VERSION = "0.1.0"

  # Add methods to handle syntactic sugar,
  # language configuration options, and paths.
  require 'treat/configurable'
  extend Treat::Configurable

  # The folders in the library and descriptions.
  Paths = {
    :tmp => 'temporary files',
    :lib => 'class and module definitions',
    :bin => 'binary files',
    :files => 'user-saved files',
    :data => 'data set files',
    :models => 'model files',
    :spec => 'spec test files'
  }

  # Add methods to provide access to common paths.
  class << self
    Paths.each do |path, _|
      define_method(path) do
        (File.dirname(__FILE__).
        split('/')[0..-2].join('/') + 
        '/' + path.to_s + '/').gsub(
        'lib/../', '')
      end
    end
  end

  require 'treat/object'
  require 'treat/kernel'
  require 'treat/downloader'
  require 'treat/languages'
  require 'treat/linguistics'
  require 'treat/entities'
  require 'treat/categories'
  require 'treat/data_set'
  require 'treat/proxies'

  # Install packages for a given language.
  def self.install(language = :english)
    require 'treat/installer'
    Treat::Installer.install(language)
  end

  # Enable syntactic sugar by default.
  Treat.sweeten!
  
end