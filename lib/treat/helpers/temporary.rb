# Require file utilities for creating and
# deleting temporary files.
require 'fileutils'

# Create a temporary file which is deleted
# after execution of the block.
def create_temp_file(ext, value = nil, &block)
  fname = Treat.paths.tmp + 
  "#{Random.rand(10000000).to_s}.#{ext}"
  File.open(fname, 'w') do |f|
    f.write(value) if value
    block.call(f.path)
  end
ensure
  File.delete(fname)
end

# Create a temporary directory, which is
# deleted after execution of the block.
def create_temp_dir(&block)
  dname = Treat.paths.tmp +
  "#{Random.rand(10000000).to_s}"
  Dir.mkdir(dname)
  block.call(dname)
ensure
  FileUtils.rm_rf(dname)
end