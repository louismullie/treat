module Treat::Entities::Abilities::Exportable
  
  def export(classification)
    ds = Treat::DataSet.new(classification)
    each_entity(*classification.types) do |e|
      ds << e
    end
    ds
  end

end
