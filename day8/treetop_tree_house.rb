require "active_support/all"
require "byebug"
require "daru"

class Forest < Daru::DataFrame
  attr_reader :width, :height

  def initialize(matrix)
    super(matrix.map.with_index.map{|l, i| [i, l]}.to_h)
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
  attr_accessor :forest, :vforest

  def initialize(input_filename)
    @forest = Forest.new(File.readlines(input_filename, chomp: true).map{|s| s.chars.map(&:to_i)})
    @vforest = forest.clone
  end

  def set_border_visibility
    vforest[0] = ["V"] * vforest.width
    vforest[forest.height - 1] = ["V"] * vforest.width
    vforest.row[0] = ["V"] * vforest.height
    vforest.row[forest.width - 1] = ["V"] * vforest.height
  end

  def set_line_visibility(vline, line)
    len = vline.size
    line = line.to_a
    (1...len).each do |k|
      vline[k] = "V" if line[k] > line[...k].max
      vline[len - k - 1] = "V" if line[len - k - 1] > line[(len - k)..].max
    end
    vline
  end

  def set_inner_visibility
    (1...forest.height).each { |k| set_line_visibility(vforest[k], forest[k]) }
    (1...forest.width).each { |k| vforest.row[k] = set_line_visibility(vforest.row[k], forest.row[k]) }
  end

  def solve1
    set_border_visibility
    set_inner_visibility
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
