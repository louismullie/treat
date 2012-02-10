module Treat::Extractors::Roles::Naive

  def self.roles(entity, options = {})
    s, v, o =
    entity.linkages.subject,
    entity.linkages.main_verb,
    entity.linkages.object
    unless (v && v.has?(:voice))
      return Treat::Features::Roles.new
    end
    s = entity.linkages.object
    if v.voice == 'active'
      p = o
    elsif v.voice == 'passive'
      p = s
    elsif v.has_feature?(:aux)
      p = s
    end
    p.set :is_patient?, true if p
    if v.voice == 'active'
      a = s
    elsif v.voice == 'passive'
      #a = object(entity, options)        # Fix this.
    end
    a.set :is_agent?, true if a
    if a && p
      a.link(p, :agent_of)
      p.link(a, :patient_of)
    end
    Treat::Features::Roles.new(a, p)
  end

end
