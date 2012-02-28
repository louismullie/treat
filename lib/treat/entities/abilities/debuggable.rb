# When Treat.debug is set to true, each call to
# #call_worker will result in a debug message being
# printed by the #print_debug function.
module Treat::Entities::Abilities::Debuggable

  @@prev = nil
  @@i = 0

  # Explains what Treat is currently doing.
  def print_debug(entity, task, worker, group, options)

    targs = group.targets.map do |target|
      target.to_s
    end
    
    if targs.size == 1
      t = targs[0]
    else
      t = targs[0..-2].join(', ') +
      ' and/or ' + targs[-1]
    end

    genitive = targs.size > 1 ?
    'their' : 'its'

    doing = ''

    human_task = task.to_s.gsub('_', ' ')

    if group.type == :transformer ||
      group.type == :computer
      
      tt = human_task
      tt = tt[0..-2] if tt[-1] == 'e'
      ed = tt[-1] == 'd' ? '' : 'ed'
      doing = "#{tt.capitalize}#{ed} #{t}"
      
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
    
    if group.to_s.index('Formatters')
      curr = doing +
      ' in format ' +
      worker.to_s
    else
      curr = doing +
      ' using ' +
      worker.to_s.gsub('_', ' ')
    end
    
    curr.gsub!('ss', 's')
    curr += '.'
    
    if curr == @@prev
      @@i += 1
    else
      if @@i > 1
        Treat::Entities.list.each do |e|
          @@prev.gsub!(e.to_s, e.to_s + 's')
        end
        @@prev.gsub!('its', 'their')
        @@prev = @@prev.split(' ').
        insert(1, @@i.to_s).join(' ')
      end
      @@i = 0
      puts @@prev     # Last call doesn't get shown.
    end
    @@prev = curr
  end
end