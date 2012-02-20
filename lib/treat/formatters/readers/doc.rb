class Treat::Formatters::Readers::DOC
  def self.read(document, options = {})
    f = `antiword #{document.file}`
    f.gsub!("\n\n", '#keep#')
    f.gsub!("\n", ' ')
    f.gsub!('#keep#', "\n\n")
    document << Treat::Entities::Zone.from_string(f)
  end
end