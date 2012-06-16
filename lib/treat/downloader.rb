# Download a file without storing it entirely in memory.
class Treat::Downloader

  require 'net/http'
  require 'fileutils'

  MIMETypes = {"application/pdf"=>:pdf, "application/x-pdf"=>:pdf, "application/acrobat"=>:pdf, "applications/vnd.pdf"=>:pdf, "text/pdf"=>:pdf, "text/x-pdf"=>:pdf, "application/msword,\n    application/doc"=>:doc, "appl/text"=>:doc, "application/vnd.msword"=>:doc, "application/vnd.ms-word"=>:doc, "application/winword"=>:doc, "application/word"=>:doc, "application/x-msw6"=>:doc, "application/x-msword"=>:doc, "text/plain"=>:txt, "text/html"=>:html, "application/xhtml+xml"=>:html, "text/xml"=>:xml, "application/xml"=>:xml, "application/x-xml"=>:xml, "application/abiword"=>:abw, "image/gif"=>:gif, "image/x-xbitmap"=>:gif, "image/gi_"=>:gif, "image/jpeg"=>:jpeg, "image/jpg"=>:jpeg, "image/jpe_"=>:jpeg, "image/pjpeg"=>:jpeg, "image/vnd.swiftview-jpeg"=>:jpeg, "image/png"=>:png, "application/png"=>:png, "application/x-png"=>:png }
  
  class << self
    attr_accessor :show_progress
  end

  self.show_progress = false

  MaxTries = 3
  
  # Download a file into destination, and return
  # the path to the downloaded file. If the filename 
  # is nil, it will set the default filename to 'top'.
  def self.download(protocol, server, dir, file = nil, target_base = nil, target_dir = nil, add_extension = false)

    require 'progressbar' if self.show_progress
    
    target_base ||= Treat.files
    target_dir ||= server
   
    dir += '/' if dir && dir[-1] != '/'
    resource = "#{dir}#{file}"
    resource = "/#{resource}" unless resource[0] == '/'
    url = "#{server}#{resource}"
    path = File.join(target_base, target_dir)
    
    unless FileTest.directory?(path)
      FileUtils.mkdir(path)
    end
    
    tries = 0
    
    begin

      Net::HTTP.start(server) do |http|

        http.use_ssl = true if protocol == 'https'

        http.request_get(resource) do |response|
          
          fn = File.basename(file, '.*')
          t = response.content_type
          ext = MIMETypes[t].to_s
          unless ext
            raise Treat::Exception,
            "Don't know how to handle MIME type #{t}."
          end
            
          fn = fn + '.' + ext
          
          file = File.open("#{path}/#{fn}", 'w')
          
          if response.content_length
            length = response.content_length
          else
            warn 'Unknown file size; ETR unknown.'
            length = 10000
          end

          pbar = self.show_progress ?
          ProgressBar.new(url, length)  : nil

          unless response.code == '200'
            raise Treat::Exception,
            "response code was not 200 "+
            "OK, but was #{response.code}. "
          end

          response.read_body do |segment|
            pbar.inc(segment.length) if pbar
            file.write(segment)
          end

          pbar.finish if pbar

        end

      end

      file.path.to_s

    rescue Exception => error
      tries += 1
      retry if tries < MaxTries
      raise Treat::Exception,
      "Couldn't download #{url}. (#{error.message})"
      file.delete
    ensure
      #file.close
    end

  end

end