# Download a file without storing it entirely in memory.
class Treat::Downloader

  require 'net/http'
  require 'fileutils'
  require 'progressbar'

  class << self
    attr_accessor :show_progress
  end

  self.show_progress = false

  # Download a file into destination, and return
  # the path to the downloaded file. If the filename 
  # is nil, it will set the default filename to 'top'.
  def self.download(protocol, server, dir, file = nil, target_base = nil, target_dir = nil)

    target_base ||= Treat.files
    target_dir ||= server
    
    resource = "#{dir}/#{file}"
    url = "#{server}/#{resource}"
    path = File.join(target_base, target_dir)
    
    unless FileTest.directory?(path)
      FileUtils.mkdir(path)
    end
    
    
    file = File.open("#{path}/#{file}", 'w')

    begin

      Net::HTTP.start(server) do |http|

        http.use_ssl = true if protocol == 'https'
        
        http.request_get(resource) do |response|

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
            "OK, but was #{response.code}. " +
            "Got #{e.message}." 
          end

          response.read_body do |segment|
            pbar.inc(segment.length) if pbar
            file.write(segment)
          end

          pbar.finish if pbar

        end

      end

      file.path.to_s

    rescue Exception => e
      raise Treat::Exception,
      "Couldn't download #{url}."
      file.delete

    ensure

      file.close

    end

  end

end