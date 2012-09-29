def require_all(path)
  p = '/ruby/gems/treat/lib/'+ 'treat/' + path
  puts p
  Dir.glob(p).each { |f| require f }
end