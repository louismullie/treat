# Download a file without storing it entirely in memory.
class Treat::Downloader

  class << self
    attr_accessor :progress_bar
    attr_accessor :download_folder
  end

  self.progress_bar = false
  self.download_folder = Treat.downloads

  require 'net/http'
  require 'fileutils'

  def self.download(server, filename, dir, protocol = 'http')

    if self.progress_bar
      silence_warnings { require 'progressbar' }
    end

    base = self.download_folder
    dest = server + '/' + dir
    make_directories_recursively(base, dest)
    fn = "#{base}#{server}/#{dir}/#{filename}"
    file = File.open(fn, 'w')

    begin

      Net::HTTP.start(server) do |http|

        http.use_ssl = true if protocol == 'https'

        df = "/#{dir}/#{filename}"
        http.request_get(df) do |response|

          if response.content_length
            length = response.content_length
          else
            if self.progress_bar
              warn 'Unknown file size; '+
              'progress bar won\'t be accurate.'
            end
            length = 10000
          end

          pbar = ProgressBar.new(filename,
          length) if self.progress_bar

          response.read_body do |segment|
            pbar.inc(segment.length) if self.progress_bar
            file.write(segment)
          end

          pbar.finish if self.progress_bar
        end

      end

      file.path.to_s

    rescue Exception => e

      raise Treat::Exception,
      "Couldn't download file " +
      "#{filename} (#{e.message})"

      file.delete

    ensure

      file.close

    end

  end


  def self.make_directories_recursively(base, path)

    p = ''
    dirs = path.split('/')
    base = self.download_folder
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
