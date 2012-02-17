class Treat::Helpers::LinguisticsLoader
  silence_warnings { require 'linguistics' }
  def self.load(language)
    begin
      l = language.to_s.upcase
      klass = nil
      silence_warnings { klass = ::Linguistics.const_get(l) }
      klass
    rescue RuntimeError
      raise "Ruby Linguistics does not have a module " +
      " installed for the #{language} language."
    end
  end
end