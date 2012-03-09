require_relative '../lib/treat'

describe Treat do

  describe "Syntactic sugar:"

  describe "#sweeten!, #unsweeten!" do

    it "respectively turn on and off syntactic sugar and " +
    "define/undefine entity builders as uppercase methods " +
    "in the global namespace" do


      Treat::Entities.list.each do |type|

        next if type == :symbol

        Treat.sweeten!
        Treat.sweetened?.should eql true


        Object.method_defined?(
        :"#{type.to_s.capitalize}").
        should eql true

        Treat.unsweeten!
        Treat.sweetened?.should eql false

        Object.method_defined?(
        :"#{type.to_s.capitalize}").
        should eql false

      end

    end

  end

  describe "Paths:" do

    paths = Treat::Paths
    paths.each do |path, files|
      describe "##{path}" do
        it "provides the path to the #{files}" do
          Treat.send(path).should be_instance_of String
        end
      end
    end

  end

end