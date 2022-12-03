require "active_support/all"

class RucksackReorg
  attr_accessor :input

  def initialize(input_filename)
    @input = File.read(input_filename).split("\n")
  end

  def compartments(line)
    halfpoint = line.size / 2
    [line[...halfpoint], line[halfpoint..]]
  end

  def priority(char)
    base = 1
    base += 26 if char.upcase == char
    base + char.downcase.ord - 'a'.ord
  end

  def solve1
    input.map do |line|
      comp1, comp2 = compartments(line)
      mistake = (comp1.chars.to_set & comp2.chars.to_set).first
      priority(mistake)
    end.sum
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
