# Quick benchmarking
# Based on rue's irbrc => http://pastie.org/179534
def quick(repetitions=100, &block)
  require 'benchmark'

  Benchmark.bmbm do |b|
    b.report {repetitions.times &block} 
  end
  nil
end


sentence = "The country, he warned, is scarred by division and is drifting towards bankruptcy and away from Europe."

section = "Hungary's troubles
Not just a rap on the knuckles

THE pressure is piling up on the beleaguered Hungarian government. Today the European Commission threatened it with legal action over several new \"cardinal\" laws that would require a two-thirds majority in parliament to overturn.

The commission is still considering the laws, but today it highlighted concerns over three issues:

- The independence of the central bank. Late last year the Hungarian parliament passed a law which expands the monetary council and takes the power to nominate deputies away from the governor and hands it to the prime minister. A separate law opens the door to a merger between the bank and the financial regulator.

- The judiciary. More than 200 judges over the age of 62 have been forced into retirement and hundreds more face the sack. The new National Judicial Authority is headed by Tünde Handó, a friend of the family of Viktor Orban, the prime minister.

- The independence of the national data authority.

After a year and a half of government by the right-wing Fidesz party, wrote Mr Bajnai in a lengthy article on the website of the Patriotism and Progress Public Policy Foundation, democracy has been destroyed in Hungary. The country, he warned, is scarred by division and is drifting towards bankruptcy and away from Europe."

require 'benchmark'
require 'stanford-core-nlp'

Benchmark.bm do |x|


  puts
  puts "Benchmark: 20 000 words (~80 pages)"
  puts
  
  s2 = section.tokenize
  
  [
    Treat::Lexicalizers::Tag,
    Treat::Lexicalizers::Category

  ].each do |group|

    puts "\n# Benchmarking #{cl(group).downcase}\n"
    group.list.each do |processor|
      
      x.report(processor.to_s) do
        next if processor == :brill
        100.times do
          s2.each_word do |word|
            word.send(group.method, processor)
          end
        end
      end

    end
    
    puts

  end

  puts "---"
  puts "Benchmark: 10 iterations on a 200-word text (~8 pages)"
  puts "---"


  [
    Treat::Processors::Chunkers,
    Treat::Processors::Segmenters,
    Treat::Processors::Tokenizers

  ].each do |group|

    puts "\n# Benchmarking #{cl(group).downcase}\n"

    group.list.each do |processor|
      next if processor == :punkt
      x.report(processor.to_s) do
        10.times do
          section.send(group.method, processor)
        end
      end

    end

    puts

  end


puts "\n# Benchmark: chunk, segment and parse a 200-word text."

  Treat::Processors::Parsers.list.each do |parser|

    x.report(parser.to_s) do
      1.times do
        section.do(:chunk, :segment, :parse => parser)
      end
    end

  end

  puts

end
