# When Treat.debug is set to true, each call to
# #call_worker will result in a debug message being
# printed by the #print_debug function.
module Treat::Entities::Entity::Debuggable
  
  # Previous state and counter.
  @@prev, @@i = nil, 0

  # Explains what Treat is currently doing.
  # Fixme: last call will never get shown.
  def print_debug(entity, task, worker, group, options)
    # Get a list of the worker's targets.
    targets = group.targets.map(&:to_s)
    
    # List the worker's targets as either
    # a single target or an and/or form
    # (since it would be too costly to
    # actually determine what target types
    # were processed at runtime for each call).
    t = targets.size == 1 ? targets[0] : targets[
    0..-2].join(', ') + ' and/or ' + targets[-1]
    
    # Add genitive for annotations (sing./plural)
    genitive = targets.size > 1 ? 'their' : 'its'
    
    # Set up an empty string and humanize task name.
    doing, human_task = '', task.to_s.gsub('_', ' ')

    # Base is "{task}-ed {a(n)|N} {target(s)}"
    if [:transformer, :computer].include?(group.type)
      tt = human_task
      tt = tt[0..-2] if tt[-1] == 'e'
      ed = tt[-1] == 'd' ? '' : 'ed'
      doing = "#{tt.capitalize}#{ed} #{t}"
    # Base is "Annotated {a(n)|N} {target(s)}"
    elsif group.type == :annotator
      if group.preset_option
        opt = options[group.preset_option]
        form = opt.to_s.gsub('_', ' ')
        human_task[-1] = ''
        human_task = form + ' ' + human_task
      end
      doing = "Annotated #{t} with " +
      "#{genitive} #{human_task}"
    end
    
    # Form is '{base} in format {worker}'.
    if group.to_s.index('Formatters')
      curr = doing + ' in format ' + worker.to_s
    # Form is '{base} using {worker}'.
    else
      curr = doing + ' using ' + worker.to_s.gsub('_', ' ')
    end
    
    # Remove any double pluralization that may happen.
    curr.gsub!('ss', 's') unless curr.index('class')
    
    # Accumulate repeated tasks.
    @@i += 1 if curr == @@prev
    
    # Change tasks, so output.
    if curr != @@prev && @@prev
      # Pluralize entity names if necessary.
      if @@i > 1
        Treat.core.entities.list.each do |e|
          @@prev.gsub!(e.to_s, e.to_s + 's')
        end
        @@prev.gsub!('its', 'their')
        @@prev = @@prev.split(' ').
        insert(1, @@i.to_s).join(' ')
      # Add determiner if singular.
      else
        @@prev = @@prev.split(' ').
        insert(1, 'a').join(' ')
      end
      # Reset counter.
      @@i = 0
      # Write to stdout.
      puts @@prev + '.'
    end
    
    @@prev = curr
  
  end
  
end