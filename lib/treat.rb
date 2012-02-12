# encoding: utf-8
module Treat

  # Treat requires Ruby 1.9 or higher.
  if RUBY_VERSION <= '1.9'
    raise 'Treat requires Ruby 1.9 or higher.'
  end

  $LOAD_PATH << '/ruby/gems/treat/lib/' # Remove for release

  # The current version of Treat.
  VERSION = "0.2.6"

  # Add methods to handle syntactic sugar,
  # language configuration options, and paths.
  require 'treat/configurable'
  extend Treat::Configurable

  # Require all files for the Treat library.
  require 'treat/object'
  require 'treat/kernel'
  require 'treat/exception'
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

Treat.sweeten!


section = "Hungary's troubles
Not just a rap on the knuckles

THE pressure is piling up on the beleaguered Hungarian government. Today the European Commission threatened it with legal action over several new \"cardinal\" laws that would require a two-thirds majority in parliament to overturn.

The commission is still considering the laws, but today it highlighted concerns over three issues:

- The independence of the central bank. Late last year the Hungarian parliament passed a law which expands the monetary council and takes the power to nominate deputies away from the governor and hands it to the prime minister. A separate law opens the door to a merger between the bank and the financial regulator.

- The judiciary. More than 200 judges over the age of 62 have been forced into retirement and hundreds more face the sack. The new National Judicial Authority is headed by Tünde Handó, a friend of the family of Viktor Orban, the prime minister.

- The independence of the national data authority.

After a year and a half of government by the right-wing Fidesz party, wrote Mr Bajnai in a lengthy article on the website of the Patriotism and Progress Public Policy Foundation, democracy has been destroyed in Hungary. The country, he warned, is scarred by division and is drifting towards bankruptcy and away from Europe."

require 'benchmark'
Benchmark.bm do |x|
  x.report do
    10.times do
      section.do(:chunk, :segment => :stanford, :tokenize => :stanford, :tag => :stanford)
    end
  end
  section.do(:chunk, :segment => :punkt, :tokenize => :stanford, :tag => :stanford).print_tree
end
