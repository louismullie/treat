class Treat::Benchmarks::Agnostic < Treat::Benchmarks::Benchmark

  def initialize
    super(Benchmarks, 'agnostic')
  end

  Benchmarks = {
    tokenize: {
      group: {
        examples: [
          ["A test phrase", ["A", "test", "phrase"]]
        ],
        generator: lambda { |entity| entity.tokens.map { |tok| tok.to_s } }
      }
    }
  }

end