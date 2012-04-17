class Treat::Classification

  attr_reader :types
  attr_reader :features
  attr_reader :question
  attr_reader :labels
  attr_reader :mode
  attr_reader :default

  def initialize(type_or_types, feature_or_features, 
    question, default = false, mode = :continuous)
    @types, @features,
    @question, @default = 
    [*type_or_types],
    [*feature_or_features], 
    question, default
    
    @mode = mode
    @labels = []
    @features.each do |cmd|
      if cmd.is_a?(Array)
        @labels << cmd[0]
      else
        @labels << cmd
      end
    end
  end

  def export_item(e, include_question = true)

    line = []

    @features.each do |cmd|
      dflt = nil
      begin
        if cmd.is_a?(Array)
          if cmd.size == 3
            r = cmd[1].call(e)
            dflt = cmd[2]
            line << (r ? r : dflt)
          elsif cmd.size == 2
            r = e.send(cmd[0])
            dflt = cmd[1]
            line << (r ? r : dflt)
          end
        else
          line << e.send(cmd)
        end
      end
    end

    if include_question
      if e.has?(@question)
        line << e.get(@question)
      else
        line << @default
      end
    end
    
    line
  end

end