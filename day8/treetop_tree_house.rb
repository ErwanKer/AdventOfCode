require "active_support/all"
require "daru"

class Forest < Daru::DataFrame
  attr_reader :width, :height

  def initialize(matrix)
    super(matrix.map.with_index.to_h.invert)
    @width = size
    @height = vectors.size
    self
  end

  def inspect
    map { |r| r.to_a.map(&:to_s).join }.join("\n")
  end

  def clone
    self.class.new(transpose.to_a.first)
  end

  def count(el)
    map { |v| v.count(el) }.sum
  end
end

class TreetopTreeHouse
  attr_accessor :forest

  def initialize(input_filename)
    @forest = Forest.new(File.readlines(input_filename, chomp: true).map(&:chars))
  end

  def set_visibility(forest)
    forest[0] = ["V"] * forest.width
    forest[forest.height - 1] = ["V"] * forest.width
    forest.row[0] = ["V"] * forest.height
    forest.row[forest.width - 1] = ["V"] * forest.height
    forest
  end

  def solve1
    vforest = set_visibility(forest.clone)
    vforest.count("V")
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

TreetopTreeHouse.run if __FILE__ == $0
