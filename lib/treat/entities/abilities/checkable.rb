# This module implements methods that are used
# by workers to determine if an entity is properly
# formatted before working on it.
module Treat::Entities::Abilities::Checkable

  # Check if the entity has the given feature,
  # and if so return it. If not, calculate the
  # requested feature if do_it is set to true,
  # or raise an exception if do_it is set to false.
  def check_has(feature, do_it = true)
    return @features[feature] if has?(feature)
    return send(feature) if do_it
    task = caller_method(2)
    g1 = Treat::Categories.lookup(task)
    g2 = Treat::Categories.lookup(feature)
    raise Treat::Exception,
    "#{g1.type.to_s.capitalize} #{task} " +
    "requires #{g2.type} #{g2.method}."
  end

  # Raises a warning and removes all children of
  # the entity if the entity has children.
  def check_hasnt_children
    return unless has_children?
    warn "Warning: can't #{caller_method(2)} "+
    "an entity that has children. Removing " +
    " all children of text \"[#{short_value}].\""
    remove_all!
  end

end
