require 'pry-byebug'

class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil)
    @data = data
    @left_child = nil
    @right_child = nil
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array = nil)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end

  def build_tree(array = @array)
    return if array.empty?

    mid = (array.length - 1) / 2.to_i
    root_node = Node.new(array[mid])
    root_node.left_child = build_tree(array.select { |e| e < array[mid] })
    root_node.right_child = build_tree(array.select { |e| e > array[mid] })
    root_node
  end

  def insert(data, node = root)
    return Node.new(data) if node.nil?

    if data < node.data
      node.left_child = insert(data, node.left_child)
    elsif data > node.data
      node.right_child = insert(data, node.right_child)
    end
    node
  end

  def find_min_value(node)
    node = node.left_child until node.left_child.nil?
    node
  end

  def delete(data, node = root)
    return node if node.nil?

    if data < node.data
      node.left_child = delete(data, node.left_child)
    elsif data > node.data
      node.right_child delete(data, node.right_child)
    else
      if node.left_child.nil?
        temp = node.right_child
        node = nil
        return temp
      elsif node.right_child.nil?
        temp = node.left_child
        node = nil
        return temp
      else
        temp = find_min_value(node.right_child)
        node.data = temp.data
        node.right_child = delete(node.data, node.right_child)
      end
    end
    node
  end

  def find(data, node = root)
    return if node.nil?

    if data < node.data
      find(data, node.left_child)
    elsif data > node.data
      find(data, node.right_child)
    else
      node
    end
  end

  def level_order
    discovered_nodes = []
    queue = [root]
    until queue.empty?
      discovered_node = queue.pop
      block_given? ? yield(discovered_node) : discovered_nodes << discovered_node
      queue.unshift(discovered_node.left_child) if discovered_node.left_child
      queue.unshift(discovered_node.right_child) if discovered_node.right_child
    end
    discovered_nodes
  end

  def inorder(node = root, node_values = [], &block)
    return if node.nil?

    inorder(node.left_child, node_values, &block)
    block_given? ? yield(node) : node_values << node.data
    inorder(node.right_child, node_values, &block)
    node_values
  end

  def preorder(node = root, node_values = [], &block)
    return if node.nil?

    block_given? ? yield(node) : node_values << node.data
    preorder(node.left_child, node_values, &block)
    preorder(node.right_child, node_values, &block)
    node_values
  end

  def postorder(node = root, node_values = [], &block)
    return if node.nil?

    postorder(node.left_child, node_values, &block)
    postorder(node.right_child, node_values, &block)
    block_given? ? yield(node) : node_values << node.data
    node_values
  end

  def height(node)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    left_height < right_height ? right_height + 1 : left_height + 1
  end

  def depth(node, current_node = root)
    return -1 if current_node.nil?

    distance = -1
    return distance + 1 if current_node == node

    distance = depth(node, current_node.left_child)
    return distance + 1 if distance >= 0

    distance = depth(node, current_node.right_child)
    return distance + 1 if distance >= 0

    distance
  end

  def balanced?
    node = root
    return false unless (height(node.left_child) - height(node.right_child)).abs <= 1

    true
  end

  def rebalance
    self.root = build_tree(inorder)
  end
end
