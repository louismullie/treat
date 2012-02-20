module Treat::Extractors::Roles::PatientAgent

  def self.roles(entity, options = {})

    s, v, o = entity.check_has(:subject),
    entity.check_has(:verb),
    entity.check_has(:object)

    return unless (v && v.has?(:voice))

    if v.get(:voice) == 'active'
      p = o
    elsif v.get(:voice) == 'passive'
      p = s
    elsif v.has?(:aux)
      p = s
    end

    p.set :is_patient?, true if p

    if v.get(:voice) == 'active'
      a = s
    elsif v.get(:voice) == 'passive'
      # Fix here
      #a = object(entity, options)
    end

    a.set :is_agent?, true if a

    if a && p
      a.link(p, :agent_of)
      p.link(a, :patient_of)
    end

  end

end
