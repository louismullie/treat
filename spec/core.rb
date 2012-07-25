require_relative '../lib/treat'

describe Treat::Core::DataSet do
=begin


p = Problem(
  Question(:is_key_sentence, :sentence, false),
  Feature(:word_count, 0)
)

p2 = Problem(
  Question(:is_key_sentence, :sentence, false),
  Feature(:word_count, 0)
)

ds = DataSet(p)

text = Paragraph("Welcome to the zoo! This is a text.")
text2 = Paragraph("Welcome here my friend. This is well, a text.")

text.chain :segment, :tokenize
text2.chain :segment, :tokenize

ds1 = text.export(p)
ds2 = text2.export(p2)

ds1.merge(ds2)

puts ds1.inspect
=end
end