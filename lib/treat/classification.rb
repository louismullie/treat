class Treat::Classification

  attr_reader :types
  attr_reader :features
  attr_reader :question
  attr_reader :labels
  attr_reader :default

  def initialize(type_or_types, features, question, default = false)

    @types, @features,
    @question, @default = 
    type_or_types,
    features, question,
    default
    
    @labels = []

    unless @types.is_a?(Array)
      @types = [@types]
    end

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

    begin
      if include_question
        line << e.send(@question)
      end
    rescue Treat::Exception
      line << @default
    end
    line[-1] = '' if line[-1].nil?
    line

  end

end
