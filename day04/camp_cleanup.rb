require "active_support/all"

class CampCleanup
  attr_accessor :input

  def initialize(input_filename)
    @input = File.read(input_filename).split("\n")
  end

  def solve1
    input.select do |line|
      assignment1, assignment2 = line.split(",").map { |sec| a, b = sec.split("-").map(&:to_i); a..b }
      assignment1.cover?(assignment2) || assignment2.cover?(assignment1)
    end.count
  end

  def solve2
    input.select do |line|
      assignment1, assignment2 = line.split(",").map { |sec| a, b = sec.split("-").map(&:to_i); a..b }
      assignment1.cover?(assignment2) || assignment2.cover?(assignment1)
    end.count
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

CampCleanup.run if __FILE__ == $0
