module Treat
  module Tests
    class TestTree < Test::Unit::TestCase
      def setup
        @root = Treat::Tree::Node.new('root node', 'root')
        @branch = Treat::Tree::Node.new('branch node', 'branch')
        @sibling = Treat::Tree::Node.new('sibling node', 'sibling')
        @leaf = Treat::Tree::Node.new('leaf node', 'leaf')
        @root << @branch << @leaf
        @root << @sibling
        @leaf.associate(@sibling, 'some dependency')
      end
      def test_branching
        assert_equal 2, @root.children.size
        assert_equal 4, @root.size
    
        assert_equal @branch, @root['branch']
        assert_equal @leaf, @root['branch']['leaf']
        assert_equal @sibling, @branch.right
        
        assert_equal @root, @root['branch'].parent
        assert_equal [@sibling], @branch.siblings
        
        assert_equal @root, @leaf.root
      end
      def test_removal
        assert_equal 1, @branch.remove_all!.size
        assert_equal @sibling, @root.remove!(@sibling)
        assert_equal @branch, @root.remove!(@branch.id)
      end
      def test_properties
        
        assert_equal 'root', @root.id
        assert_equal 'branch', @branch.id
        assert_equal 'leaf', @leaf.id

        assert_equal 'root node', @root.value
        assert_equal 'branch node', @branch.value
        assert_equal 'leaf node', @leaf.value
        
        assert_equal false, @root.has_features?
        assert_equal false, @branch.has_features?
        assert_equal false, @leaf.has_features?

        assert_equal true, @root.has_children?
        assert_equal true, @branch.has_children?
        assert_equal false, @leaf.has_children?

        assert_equal false, @root.has_parent?
        assert_equal true, @branch.has_parent?
        assert_equal true, @leaf.has_parent?
        
        assert_equal false, @root.has_edges?
        assert_equal false, @branch.has_edges?
        assert_equal true, @leaf.has_edges?
        
      end
    end
  end
end
