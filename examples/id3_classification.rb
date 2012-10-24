# encoding: utf-8
require_relative '../lib/treat'
include Treat::Core::DSL

d = document('http://en.wikipedia.org/wiki/NOD_mouse').
apply(:chunk, :segment, :tokenize, serialize: [:xml, {file: 't.xml'}])
d.each_sentence { |s| s.set :is_spam, rand(2) }
question = question(:is_spam, :sentence, :discrete)
problem = problem(question, feature(:punctuation_count))

total, match = 0.0, 0.0
d.sentences.map do |s| 
  pred = s.classify(:id3, training: d.export(problem))
  match += 1 if s.is_spam == pred; total += 1
end

puts "Total sentences: #{total}"
puts "Precision: #{match/total}"