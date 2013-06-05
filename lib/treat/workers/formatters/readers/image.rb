# This class is a wrapper for the Google Ocropus
# optical character recognition (OCR) engine.
#
# "OCRopus(tm) is a state-of-the-art document
# analysis and OCR system, featuring pluggable
# layout analysis, pluggable character recognition,
# statistical natural language modeling, and multi-
# lingual capabilities."
#
# Original paper: Google Ocropus Engine: Breuel,
# Thomas M. The Ocropus Open Source OCR System.
# DFKI and U. Kaiserslautern, Germany.
class Treat::Workers::Formatters::Readers::Image

  #  Read a file using the Google Ocropus reader.
  #
  # Options:
  #
  # - (Boolean) :silent => whether to silence Ocropus.
  def self.read(document, options = {})

    read = lambda do |doc|
      self.create_temp_dir do |tmp|
        # `ocropus book2pages #{tmp}/out #{doc.file}`
        # `ocropus pages2lines #{tmp}/out`
        # `ocropus lines2fsts #{tmp}/out`
        # `ocropus buildhtml #{tmp}/out > #{tmp}/output.html`

        `ocropus-nlbin -o #{tmp}/out #{doc.file}`
        `ocropus-gpageseg #{tmp}/out/????.bin.png --minscale 2`
        `ocropus-rpred #{tmp}/out/????/??????.bin.png`
        `ocropus-hocr #{tmp}/out/????.bin.png -o #{tmp}/book.html`
        doc.set :file,  "#{tmp}/book.html"
        doc.set :format, :html

        doc = doc.read(:html)
      end
    end


    Treat.core.verbosity.silence ? silence_stdout {
    read.call(document) } : read.call(document)

    document

  end

  # Create a dire that gets deleted after execution of the block.
  def self.create_temp_dir(&block)
    if not FileTest.directory?(Treat.paths.tmp)
      FileUtils.mkdir(Treat.paths.tmp)
    end
    dname = Treat.paths.tmp +
    "#{Random.rand(10000000).to_s}"
    Dir.mkdir(dname)
    block.call(dname)
  ensure
    FileUtils.rm_rf(dname)
  end

end