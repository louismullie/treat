class Treat::Builder
  def initialize(&block)
    i = 'include Treat::Core::DSL'
    eval(i, block.binding)
    block.call
  end
end