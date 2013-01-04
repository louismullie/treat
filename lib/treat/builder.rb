class Treat::Builder
  include Treat::Core::DSL
  def initialize(&block)
    instance_exec(&block)
  end
end