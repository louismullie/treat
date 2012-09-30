# encoding: utf-8
require_relative '../lib/treat'

d = Document('test.html')
d.chunk

d.visualize :dot, file: 'test.dot'

puts d.to_s