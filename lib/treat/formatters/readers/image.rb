# This class is a wrapper for the Google Ocropus
# optical character recognition (OCR) engine.
#
# "OCRopus(tm) is a state-of-the-art document
# analysis and OCR system, featuring pluggable
# layout analysis, pluggable character recognition,
# statistical natural language modeling, and multi-
# lingual capabilities."
#
# Original paper:
#
# Breuel, Thomas M. The Ocropus Open Source OCR System.
# DFKI and U. Kaiserslautern, Germany.
class Treat::Formatters::Readers::Image

  #  Read a file using the Google Ocropus reader.
  #
  # Options:
  #
  # - (Boolean) :silent => whether to silence Ocropus.
  def self.read(document, options = {})
    
    read = lambda do |doc|
      create_temp_dir do |tmp|
        `ocropus book2pages #{tmp}/out #{doc.file}`
        `ocropus pages2lines #{tmp}/out`
        `ocropus lines2fsts #{tmp}/out`
        `ocropus buildhtml #{tmp}/out > #{tmp}/output.html`
        f = document.file
        doc.remove_all!
        doc.set :file,  "#{tmp}/output.html"
        doc.read(:html)
        doc.set :file, f
      end
    end
    
    options[:silent] ?
    silence_stdout { read.call(document) } :
    read.call(document)
    
    d.set :format, :image
    
  end
  
end