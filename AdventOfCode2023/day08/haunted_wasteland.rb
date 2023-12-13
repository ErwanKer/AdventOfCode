require_relative "../lib.rb"
require "active_support/all"
require "progress_bar"
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
    bar = ProgressBar.new(nodes.size)
    paths = nodes.map do |starting_node|
      node = starting_node
      step = 0
      path = []
      until (curr_sit = [node, step % instructions.size]).in? path
        path << curr_sit
        direction = instructions[step % instructions.size]
        node = map[node][direction]
        step += 1
      end
      bar.increment!
      path.map(&:first)
    end
    endings = paths.map { |nodes| nodes.map.with_index.find { |node, i| node.ends_with?("Z") } }
    endings.map(&:last).reduce(1, :lcm)
  end
end

HauntedWasteland.run if __FILE__ == $0
