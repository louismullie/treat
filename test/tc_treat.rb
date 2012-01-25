module Treat
  module Tests
    class TestTreat < Test::Unit::TestCase
      
      def test_edulcoration
        Treat.edulcorate
        assert_equal true, Treat.edulcorated?
        Treat::Entities.list.each do |klass|
          next if klass == :symbol
          assert_nothing_raised do
            begin
              Object.send(:"#{klass.to_s.capitalize}")
            rescue Treat::Exception
              next
            rescue
              raise
            end
          end
        end 
        Treat.unedulcorate
        assert_equal false, Treat.edulcorated?
        Treat::Entities.list.each do |klass|
          next if klass == :symbol
          assert_raise(NoMethodError) do
            Object.send(:"#{klass.to_s.capitalize}")
          end
        end
      end
      
      def test_modules_loaded?
        ['exception',
        'languages',
        'entities',
        'feature',
        'category',
        'group',
        'detectors',
        'formatters',
        'processors',
        'lexicalizers',
        'extractors',
        'inflectors',
        'proxies'].each do |klass|
          assert_nothing_raised do
            Treat.const_get klass.capitalize
          end
        end
      end
      
      def test_paths
        assert_not_nil Treat.lib
        assert_not_nil Treat.bin
        assert_not_nil Treat.test
        assert_not_nil Treat.tmp
      end
      
      def test_file_permissions
        assert_equal true, File.writable?(Treat.lib + '/../tmp')
      end
      
    end
  end
end
