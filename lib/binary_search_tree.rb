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
    @array = array
    @root = nil
  end
end
