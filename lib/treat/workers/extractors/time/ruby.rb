# Date extraction using Ruby's standard library
# DateTime.parse() method.
class Treat::Workers::Extractors::Time::Ruby


  require 'date'

  # Return a DateTime object representing the date/time
  # contained within the entity, using Ruby's native
  # date/time parser. This extractor is suitable for the
  # detection of well-structured dates and times, such as
  # 2011/02/03 5:00.
  #
  # Options: none.
  def self.time(entity, options = {})
    begin
      DateTime.parse(entity.to_s)
    rescue
      nil
    end
  end

end