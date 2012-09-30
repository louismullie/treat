# This module implements methods that are used
# by workers to determine if an entity is properly
# formatted before working on it.
module Treat::Entities::Entity::Checkable

  # Check if the entity has the given feature,
  # and if so return it. If not, calculate the
  # requested feature if do_it is set to true,
  # or raise an exception if do_it is set to false.
  def check_has(feature, do_it = true)
    return @features[feature] if has?(feature)
    return send(feature) if do_it
    task = caller_method(2) # This is dangerous !
    g1 = Treat::Workers::Category.lookup(task)
    g2 = Treat::Workers::Category.lookup(feature)

    raise Treat::Exception,
    "#{g1.type.to_s.capitalize} #{task} " +
    "requires #{g2.type} #{g2.method}."
  end

  # Raises an error if the entity has children.
  def check_hasnt_children
    return unless has_children?
    raise Treat::Exception,
    "Warning: can't #{caller_method(2)} "+
    "the text \"#{short_value}\", because it " +
    "already has children."
  end

end
