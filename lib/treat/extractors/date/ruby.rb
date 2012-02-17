# A wrapper for Ruby's native date/time parsing.
class Treat::Extractors::Date::Ruby

  # Require Ruby's date module.
  require 'date'

  # Return a DateTime object representing the date/time
  # contained within the entity, using Ruby's native
  # date/time parser. This extractor is suitable for the
  # detection of well-structured dates and times, such as
  # 2011/02/03 5:00.
  #
  # Options: none.
  def self.date(entity, options = {})
    begin
      date = ::DateTime.parse(
      entity.to_s.strip.gsub('\/', '/')
      ).to_date
    rescue
      nil
    end
  end

end