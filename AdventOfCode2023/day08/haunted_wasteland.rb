require_relative "../lib.rb"
require "active_support/all"
require "byebug"

class HauntedWasteland < Solver
  attr_accessor :instructions, :map

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @instructions = lines.first.chars
    @map = lines[2..].map do |line|
      node, paths = line.split(" = ")
      left, right = paths.tr("()", "").split(", ")
      [node, {"L" => left, "R" => right}]
    end.to_h
  end

  def solve1
    node = "AAA"
    steps = 0
    while node != "ZZZ"
      direction = instructions[steps % instructions.size]
      node = map[node][direction]
      steps += 1
    end
    steps
  end

  def solve2
    nodes = map.keys.select { |node| node.ends_with?("A") }
    paths = nodes.map do |starting_node|

    endgit 
    steps = 0
    until nodes.all? { |node| node.ends_with?("Z") }
      p [steps, nodes]
      direction = instructions[steps % instructions.size]
      nodes = nodes.map { |node| map[node][direction] }
      steps += 1
    end
    steps
  end
end

HauntedWasteland.run if __FILE__ == $0

9_123_456_789 too low
625_203_587
