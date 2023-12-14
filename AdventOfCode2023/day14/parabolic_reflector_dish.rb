require_relative "../lib.rb"
require "active_support/all"
require "byebug"

class ParabolicReflectorDish < Solver
  attr_accessor :input

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @input = lines
  end

  def move_rocks(line)
    fixed_rocks = line.chars.map.each_with_index.to_a.select{ |z,_| z == "#" }.map(&:last)
    fixed_points = [0] + fixed_rocks + [line.size]
    new_line = line.dup
    fixed_points.each_cons(2) do |x, y|
      s = (x.zero? && line[x] != "#") ? x : x + 1
      next if s == y || line[s].nil?

      round_rocks = line[s...y].count("O")
      new_line[s..y] = line[s..y].gsub("O", ".")
      new_line[s...(s + round_rocks)] = "O" * round_rocks
    end
    new_line
  end

  def tilt_north(platform)
    sideways = platform.map(&:chars).transpose.map(&:join)
    sideways.map { |line| move_rocks(line) }.map(&:chars).transpose.map(&:join)
  end

  def print_line_moves
    side_map = input.map(&:chars).transpose.map(&:join)
    side_tilt = tilt_north(input).map(&:chars).transpose.map(&:join)
    side_map.zip(side_tilt).each { |a, b| p "#{a} => #{b}" }
  end

  def solve1
    max_load = input.size
    tilt_north(input).map.with_index do |line, i|
      line.count("O") * (max_load - i)
    end.sum
  end

  def solve2
    "not implemented yet"
  end
end

ParabolicReflectorDish.run if __FILE__ == $0
