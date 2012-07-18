class Treat::Core::Problem

  attr_accessor :question
  attr_accessor :features
  attr_accessor :labels
  
  def initialize(question, *features)
    @question = question
    @features = features
    @labels = @features.map { |f| f.name }
  end

  def export_item(e, include_answer = true)
    line = []
    @features.each do |feature|
      r = feature.proc ? 
      feature.proc.call(e) : 
      e.send(feature.name)
      line << r || feature.default
    end
    return line unless include_answer
    line << (e.has?(@question.name) ? 
    e.get(@question.name) : @question.default)
    line
  end

end