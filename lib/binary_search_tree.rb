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
end
