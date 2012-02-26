module Treat

  #$LOAD_PATH << '/ruby/gems/treat/lib/' # Remove for release

  # Require custom exception cass.
  require 'treat/exception'

  # Treat requires Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise Treat::Exception,
    'Treat requires Ruby 1.9 or higher.'
  end

  # The current version of Treat.
  VERSION = "0.2.9"

  # Add methods to handle syntactic sugar,
  # language configuration options, and paths.
  require 'treat/configurable'
  extend Treat::Configurable

  # Add methods to provide access to common paths.
  def self.lib; File.dirname(__FILE__) + '/'; end
  def self.tmp; lib + '../tmp/'; end
  def self.bin; lib + '../bin/'; end
  def self.data; lib + '../data/'; end
  def self.models; lib + '../models/'; end
  def self.test; lib + '../test/'; end
  def self.downloads; lib + '../downloads/'; end

  # Require all files for the Treat library.
  require 'treat/object'
  require 'treat/kernel'
  require 'treat/downloader'
  require 'treat/languages'
  require 'treat/entities'
  require 'treat/categories'
  require 'treat/proxies'

  # Install packages for a given language.
  def self.install(language = :english)
    require 'treat/installer'
    Treat::Installer.install(language)
  end

end