require 'yomu'

# This class is a wrapper for Yomu.
# Yomu is a library for extracting text and metadata from files and documents
# using the Apache Tika content analysis toolkit.
class Treat::Workers::Formatters::Readers::Document
  # Extract the readable text from any document.
  #
  # Options: none.
  def self.read(document, options = {})
    yomu = Yomu.new(document.file)

    document.value = yomu.text
    document.set :format, yomu.mimetype.extensions.first
    document
  end
end
