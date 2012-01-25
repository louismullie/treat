module Treat
  # This module provides an abstract tree structure with
  # nodes having an id, a value, children, features and edges.
  module Tree
    # This class models the nodes for an N-ary tree data structue
    # with unique identifiers, text value, children, features
    # (annotations) and edges. 
    #
    # This class was tightly based on the 'rubytree' gem.
    # RubyTree is licensed under the BSD license and can
    # be found at http://rubytree.rubyforge.org/rdoc/.
    # I have made several modifications in order to better
    # suit this library and to avoid monkey patching.
    class Node
      # Iterate over each children in the node.
      def each
        @children.each { |child| yield child }
      end
      # A string containing the node's value (or empty).
      attr_accessor :value
      # A unique identifier for the node.
      attr_reader :id
      # An array containing the children of this node.
      attr_reader :children
      # A hash containing the features of this node.
      attr_accessor :features
      # A hash containing the edges that link this 
      # node to other nodes.
      attr_accessor :edges
      # The parent of the node.
      attr_accessor :parent
      # Initialize the node with its value and id.
      # Setup containers for the children, features
      # and edges of this node.
      def initialize(value, id = nil)
        @parent = nil
        @value, @id = value, id
        @children = []
        @children_hash = {}
        @features = {}
        @edges = {}
      end
      # Boolean - does the node have edges?
      def has_edges?; !@edges.empty?; end
      # Boolean - does the node have children?
      def has_children?; !@children.empty?; end
      # Boolean - does the node have features?
      def has_features?; !@features.empty?; end
      # Boolean - does the node have a parent?
      def has_parent?; !@parent.nil?; end
      # Boolean - does the node not have a parent?
      def is_root?; @parent.nil?; end
      # Remove this node from its parent and set as root.
      def set_as_root!; @parent = nil; self; end
      # Boolean - is this node a leaf ?
      # This is overriden in leaf classes.
      def is_leaf?; !has_children?; end
      # Add the nodes to the given child.
      # This may be used with several nodes,
      # for example: node << [child1, child2, child3]
      def <<(nodes)
        nodes = [nodes] unless nodes.is_a? Array
        raise 'Trying to add a nil node.' if nodes.include? nil
        nodes.each do |node|
          node.parent = self
          @children << node
          @children_hash[node.id] = node
        end
        nodes[0]
      end
      # Retrieve a child node by name or index.
      def [](name_or_index)
        if name_or_index == nil
          raise Treat::Exception, 
          "Non-nil name or index needs to be provided." 
        end
        if name_or_index.kind_of?(Integer) && 
          name_or_index < 1000
          @children[name_or_index]
        else
          @children_hash[name_or_index]
        end
      end
      # Remove the supplied node or id of a node from the children.
      def remove!(ion)
        return nil unless ion
        if ion.is_a? Treat::Tree::Node
          @children.delete(ion)
          @children_hash.delete(ion.id)
          ion.set_as_root!
        else
          @children.delete(@children_hash[ion])
          @children_hash.delete(ion)
        end
      end
      # Remove all children.
      def remove_all!
        @children.each { |child| child.set_as_root! }
        @children.clear
        @children_hash.clear
        self
      end
      # Previous sibling from the same parent.
      def next_sibling
        return nil if is_root?
        id = @parent.children.index(self)
        @parent.children.at(id + 1) if id
      end
      # Return the sibling N positions to the left of this one.
      def left(n = 1); sibling(-1*n); end
      # Return the sibling N positions to the right of this one.
      def right(n = 1); sibling(1*n); end
      # Return the sibling with position #pos versus 
      # this one. #pos can be ... -1, 0, 1, ...
      def sibling(pos)
        return nil if is_root?
        id = @parent.children.index(self)
        @parent.children.at(id + pos)
      end
      # Return all brothers and sisters of this node.
      def siblings
        r = @parent.children.dup
        r.delete(self)
        r
      end
      # Total number of nodes in the subtree, including this one.
      def size
        @children.inject(1) { |sum, node| sum + node.size }
      end
      # Set the feature to the supplied value.
      def set(feature, value)
        @features ||= {}
        @features[feature] = value
      end
      # Return the depth of this node in the tree.
      def depth
        return 0 if is_root?
        1 + parent.depth
      end
      # Does the entity have a feature ?
      def has_feature?(feature)
        @features.has_key?(feature) ||
        [:id, :value, :children, :edges].include?(feature)
      end
      alias :has? :has_feature?
      # Link this node to the target node with
      # the supplied edge type.
      def associate(id_or_node, edge_type = nil)
        if id_or_node.is_a? Treat::Tree::Node
          id = root.find(id_or_node).id
        else
          id = id_or_node
        end
        @edges[id] = edge_type if id
      end
      # Find the node in the tree with the given id.
      def find(id_or_node)
        if id_or_node.is_a? self.class
          id = id_or_node.id
        else
          id = id_or_node
        end
        return @children_hash[id] if @children_hash[id]
        self.each do |child|
          r = child.find(id)
          return r if r.is_a? Tree::Node
        end
      end
      # Find the root of the tree within which
      # this node is contained.
      def root
        return self if !has_parent?
        ancestor = @parent
        while ancestor.has_parent?
          ancestor = ancestor.parent
        end
        ancestor
      end
    end
  end
end
