# encoding: utf-8
require_relative '../lib/treat'
include Treat::Core::DSL

question = question(:is_spam, :sentence, 0)
problem = problem(question, feature(:punctuation_count), feature(:word_count))

d = document('http://en.wikipedia.org/wiki/NOD_mouse').
apply(:chunk, :segment, :tokenize, serialize: [:xml, {file: 'd.xml'}])
d2 = document('http://en.wikipedia.org/wiki/Academic_studies_about_Wikipedia').
apply(:chunk, :segment => :scalpel, :tokenize => :ptb, serialize: [:xml, {file: 'd2.xml'}])

d.sentences[0..17].each { |s| s.set :is_spam, 0 }
d.sentences[17..-1].each { |s| s.set :is_spam, 1 }
d2.sentences[0..81].each { |s| s.set :is_golden, 0 }
d2.sentences[81..-1].each { |s| s.set :is_golden, 1 }

tp, fp, tn, fn = 0.0, 0.0, 0.0, 0.0

d2.sentences.map do |s| 
  pred = s.classify(:svm, training: d.export(problem))
  if pred == 1
    tp += 1 if s.is_golden == 1
    fp += 1 if s.is_golden == 0
  else
    tn += 1 if s.is_golden == 0
    fn += 1 if s.is_golden == 1
  end
end

puts "Precision: #{tp/(tp + fp)}"
puts "Recall: #{tp/(tp + fn)}"