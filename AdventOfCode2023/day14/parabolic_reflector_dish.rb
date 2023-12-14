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

  def cycle(platform)
    north_cycle = tilt_north(platform)
    west_cycle = tilt_north(north_cycle.map(&:chars).transpose.map(&:join))
    south_cycle = tilt_north(west_cycle.map(&:chars).map(&:reverse).transpose.map(&:join))
    east_cycle = tilt_north(south_cycle.map(&:chars).map(&:reverse).transpose.map(&:join))
    east_cycle.map(&:chars).transpose.map(&:reverse).reverse.map(&:join)
  end

  def guess_end_state
    round_rocks = input.join.count("O")
    empty_input = input.join(" ").gsub("O", ".").split
    empty_input.reverse.map do |line|
      line if round_rocks.zero?

      line.reverse!
      line.size.times do |i|
        break if round_rocks.zero?

        next if line[i] != "."
        line[i] = "O"
        round_rocks -= 1
      end
      line.reverse
    end.reverse
  end

  def solve1
    max_load = input.size
    tilt_north(input).map.with_index do |line, i|
      line.count("O") * (max_load - i)
    end.sum
  end

  def solve2
    max_load = input.size
    n_cycles = 1000000000
    cycles = [input]
    n_cycles.times do |i|
      new_platform = cycle(cycles.last)
      cycled = new_platform.in?(cycles)
      cycles << new_platform
      break if cycled
    end

    cycle_start = cycles.index(cycles.last)
    cycle_size = cycles.size - cycle_start - 1
    platform = cycles[cycle_start...-1][(n_cycles - cycle_start)  % cycle_size]

    platform.map.with_index do |line, i|
      line.count("O") * (max_load - i)
    end.sum

    #max_load = input.size
    #guess_end_state.map.with_index do |line, i|
    #  line.count("O") * (max_load - i)
    #end.sum
  end
end

ParabolicReflectorDish.run if __FILE__ == $0
