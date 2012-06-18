# This class is a wrapper for the 'ruby-readability'
# gem, which extracts the primary readable content
# of a web page by using set of handwritten rules.
#
# Project homepage:
# https://github.com/iterationlabs/ruby-readability
class Treat::Workers::Formatters::Readers::HTML
  
  silence_warnings { require 'ruby-readability' }

  # By default, don't backup the original HTML
  DefaultOptions = {
    :keep_html => false,
    :tags => %w[p div h1 h2 h3 ul ol dl dt li]
  }

  # Read the HTML document and strip it of its markup.
  #
  # Options:
  #
  #   text when cleaning the document (default: false).
  # - (Boolean) :remove_empty_nodes => remove <p> tags
  #   that have no text content
  # - (String) :encoding => if the page is of a known
  #   encoding, you can specify it; if left unspecified,
  #   the encoding will be guessed (only in Ruby 1.9.x)
  # - (String) :html_headers => in Ruby 1.9.x these will
  #   be passed to the guess_html_encoding gem to aid with
  #   guessing the HTML encoding.
  # - (Array of String) :tags  => the base whitelist of
  #   tags to sanitize, defaults to %w[div p].
  #   also removes p tags that contain only images
  # - (Array of String) :attributes => list allowed attributes
  # - (Array of String) :ignore_image_format => for use with images.
  # - (Numeric) :min_image_height => minimum image height for images.
  # - (Numeric) :min_image_width => minimum image width for images.
  def self.read(document, options = {})

    # set encoding with the guess_html_encoding
    options = DefaultOptions.merge(options)
    html = File.read(document.file)

    silence_warnings do
      # Strip comments
      html.gsub!(/<!--[^>]*-->/m, '')
      d = Readability::Document.new(html, options)
      document.value = "<h1>#{d.title}</h1>\n" + d.content
      document.set :format, :html
    end

    document

  end

end
