module Treat::Entities::Abilities::Exportable
  
  def export(problem)
    ds = Treat::Learning::DataSet.new(problem)
    each_entity(problem.question.target) do |e|
      ds << e
    end
    ds
  end

end