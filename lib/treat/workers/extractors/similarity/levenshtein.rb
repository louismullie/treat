class Treat::Workers::Extractors::Similarity
  # Default options.
  DefaultOptions = {
    with: '',
    ins_cost: 1,
    del_cost: 1,
    sub_cost: 1
  }
  # Return the levensthein distance between
  # two strings taking into account the costs
  # of insertion, deletion, and substitution.
  # Used by did_you_mean? to detect typos.
  def self.similarity(entity, options)
    first, other = entity.to_s, options[:with].to_s
    options = DefaultOptions.merge(options)
    other, ins, del, sub, = options[:with],
    options[:inst_cost], options[:del_cost],
    options[:sub_cost]
    fill, dm = [0] * (first.length - 1).abs,
    [(0..first.length).collect { |i| i * ins}]
    for i in 1..other.length
      dm[i] = [i * del, fill.flatten]
    end
    for i in 1..other.length
      for j in 1..first.length
        dm[i][j] = [
          dm[i-1][j-1] + (first[i-1] == 
          other[i-1] ? 0 : sub), dm[i][j-1] + 
          ins, dm[i-1][j] + del
        ].min
      end
    end
    dm[other.length][first.length]
  end

end