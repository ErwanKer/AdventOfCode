require "active_support/all"

class RucksackReorg
  attr_accessor :input

  def initialize(input_filename)
    @input = File.read(input_filename).split("\n")
  end

  def solve1
    "not implemented yet"
  end

  def solve2
    "not implemented yet"
  end

  def self.run
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

RucksackReorg.run if __FILE__ == $0
