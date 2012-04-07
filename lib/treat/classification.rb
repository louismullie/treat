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
      begin
        if cmd.is_a?(Array)
          line << cmd[1].call(e)
        else
          line << e.send(cmd)
        end
      rescue Treat::Exception
        dflt = (
        (cmd.is_a?(Array) && cmd[2]) ?
        cmd[2] : nil
        )
        line << dflt
      end
    end

    if include_question
      if e.has?(@question)
        line << e.get(@question)
      else
        line << @default
      end
    end
    
    line[-1] = '' if line[-1].nil?
    line
  end

end
