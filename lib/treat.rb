module Treat

  $LOAD_PATH << '/ruby/gems/treat/lib/' # Remove for release

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
  require 'treat/data_set'
  require 'treat/proxies'

  # Install packages for a given language.
  def self.install(language = :english)
    require 'treat/installer'
    Treat::Installer.install(language)
  end

end

Treat.sweeten!
Treat.debug = true
Treat.silence = false

c = Collection 'economist'
c.do(:chunk, :segment, :tokenize, :name_tag, :tf_idf, :keywords)

cl = Treat::Classification.new(
  :sentence,
  [
    :position_in_paragraph,
    :position_from_end_of_paragraph,
    :word_count, :number_count,
    :named_entity_count
  ],
  :is_key_sentence?
)

c.each_sentence do |s|
  if s.has?(:keyword_count) 
    s.set :is_key_sentence?, true if s.keyword_count > 1
  elsif s.has?(:named_entity_count)
    s.set :is_key_sentence?, true if s.named_entity_count > 1
  else
    s.set :is_key_sentence?, false
  end
end

ds = c.export(cl)
ds.save('test-set2.yml')

ts = Treat::DataSet.open('test-set2.yml')

c.each_document do |d|

  puts 
  puts d.titles[0].to_s
  puts
  
  sentences = []

  d.each_sentence do |sentence|

    if sentence.classify(:training => ts)
      sentences << sentence.to_s
    end
  
  end
  
  puts sentences.join(' ')
  
end