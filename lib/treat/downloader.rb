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
  # the path to the downloaded file.
  def self.download(protocol, server, dir, file, destination = nil)

    unless destination
      path = server + '/' + dir
      destination = Treat.files
      make_directories_recursively(destination, path)
    end

    resource = "#{server}/#{dir}/#{file}"
    file = File.open("#{destination}#{resource}", 'w')

    begin

      Net::HTTP.start(server) do |http|

        http.use_ssl = true if protocol == 'https'

        df = "/#{dir}/#{file}"
        http.request_get(df) do |response|

          if response.content_length
            length = response.content_length
          else
            warn 'Unknown file size; ETR unknown.'
            length = 10000
          end

          pbar = self.show_progress ? 
          ProgressBar.new(resource, length)  : nil

          unless response.code == '200'
            raise Treat::Exception,
            "response code was not 200 "+
            "OK, but was #{response.code}"
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
      "Couldn't download #{resource} (#{e.message})."
      file.delete

    ensure

      file.close

    end

  end


  def self.make_directories_recursively(base, path)

    p = ''
    dirs = path.split('/')

    dirs.each do |dir|

      next if dir == ''
      p << dir + '/'
      unless File.readable?(base + p)
        FileUtils.mkdir(base + p)
      end
    end

    p

  end

end
