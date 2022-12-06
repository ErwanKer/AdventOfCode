require "active_support/all"

class TuningTrouble
  SEQSIZE = 4

  attr_accessor :input

  def initialize(input_filename)
    @input = File.read(input_filename).strip
  end

  def solve1
    (0..(input.length - SEQSIZE)).each do |i|
      uniq_length = input[i...(i + SEQSIZE)].chars.uniq.length
      return i + SEQSIZE if uniq_length == SEQSIZE
    end
    0 # error value
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

TuningTrouble.run if __FILE__ == $0
