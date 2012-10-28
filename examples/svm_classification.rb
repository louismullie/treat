# encoding: utf-8
require_relative '../lib/treat'
include Treat::Core::DSL

question = question(:is_spam, :sentence)
problem = problem(question, feature(:punctuation_count), feature(:word_count))

d = document('http://en.wikipedia.org/wiki/NOD_mouse').
apply(:chunk, :segment, :tokenize, serialize: [:xml, {file: 't.xml'}])

d.sentences[0..17].each { |s| s.set :is_spam, 0 }
d.sentences[17..-1].each { |s| s.set :is_spam, 1 }

total, match = 0.0, 0.0
d.sentences.map do |s| 
  pred = s.classify(:svm, training: d.export(problem))
  puts "#{total}: #{pred} - #{s.to_s}"
  match += 1 if s.is_spam == pred; total += 1
end

puts "Total sentences: #{total}"
puts "Precision: #{match/total}"