require "active_support/all"
require "byebug"

class CubeConundrum
  attr_accessor :games

  class Cubes
    attr_accessor :red, :green, :blue

    def initialize(input_line)
      vals = input_line.split(",").map do |number_color|
        number, color = number_color.strip.split
        [color, number.to_i]
      end.to_h
      @red = vals["red"] || 0
      @green = vals["green"] || 0
      @blue = vals["blue"] || 0
    end

    def possible?(ref_cubes)
      red <= ref_cubes.red && green <= ref_cubes.green && blue <= ref_cubes.blue
    end
  end

  def initialize(input, direct_input: false)
    input = (direct_input ? input : File.read(input)).split("\n")
    @games = input.map do |line|
      game_id, game_cubes = line.split(":").map(&:strip)
      [game_id.split.last.to_i, game_cubes.split(";").map { |gc| Cubes.new(gc)}]
    end.to_h
  end

  def solve1
    ref_cubes = Cubes.new("12 red, 13 green, 14 blue")
    games.select do |_, game_cubes|
      game_cubes.all? { |game| game.possible?(ref_cubes) }
    end.keys.sum
  end

  def solve2
    "not implemented yet"
  end

  def self.run
    if ARGV.present?
      ARGV.each do |arg|
        solver = new(arg, direct_input: true)
        puts "Solving for {#{arg}}: solution 1 is #{solver.solve1} and solution 2 is #{solver.solve2}"
      end
    else
      source_folder = File.dirname(__FILE__)
      example_solver = new("#{source_folder}/example")
      puzzle_solver = new("#{source_folder}/puzzle")
      puts "Solving first part :"
      puts "=> example solution : #{example_solver.solve1}"
      puts "=> puzzle solution : #{puzzle_solver.solve1}"
      puts "Solving second part :"
      puts "=> example solution : #{example_solver.solve2}"
      puts "=> puzzle solution : #{puzzle_solver.solve2}"
    end
  end
end

CubeConundrum.run if __FILE__ == $0
