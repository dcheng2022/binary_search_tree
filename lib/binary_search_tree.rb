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
end
