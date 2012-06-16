require_relative '../lib/treat'

describe Treat do

  describe "Syntactic sugar:"

  describe "#sweeten!, #unsweeten!" do

    it "respectively turn on and off syntactic sugar and " +
    "define/undefine entity builders as uppercase methods " +
    "in the global namespace" do

      Treat.core.entities.each do |type|

        next if type == :symbol

        Treat::Config.sweeten!

        Treat.core.syntax[:sweetened?].should eql true


        Object.method_defined?(
        :"#{type.to_s.capitalize}").
        should eql true

        Treat::Config.unsweeten!

        Treat.core.syntax[:sweetened?].should eql false
        
        Object.method_defined?(type.to_s.capitalize.intern).should eql false
=begin
        Object.method_defined?(
        :"#{type.to_s.capitalize}").
        should eql false
=end
      end

    end

  end

  describe "Paths:" do

    paths = Treat.core.paths[:description]
    # Check IO for bin, files, tmp, models. Fix.
    paths.each do |path, files|
      describe "##{path}" do
        it "provides the path to the #{files}" do
          Treat.paths.send(path).should be_instance_of String
        end
      end
    end

  end

end