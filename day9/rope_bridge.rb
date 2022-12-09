require "active_support/all"
require "byebug"

Coords = Struct.new("Coords", :row, :col)

class RopeGrid
  attr_accessor :matrix, :nrows, :ncols, :min_corner, :max_corner, :rope, :origin
  alias_method :to_s, :inspect

  def initialize(rope_length:)
    @matrix = {}
    @origin = Coords.new(0, 0)
    @min_corner = Coords.new(0, 0)
    @max_corner = Coords.new(1, 1)
    @rope = rope_length.times.map { Coords.new(origin.row, origin.col) }
  end

  def inspect
    nrows = max_corner.row - min_corner.row
    ncols = max_corner.col - min_corner.col
    res = nrows.times.map { ["."] * ncols }
    matrix.each do |coords, value|
      res[coords[0] - min_corner.row][coords[1] - min_corner.col] = value
    end
    res[origin.row - min_corner.row][origin.col - min_corner.col] = "s"
    if rope.length == 2
      res[rope.last.row - min_corner.row][rope.last.col - min_corner.col] = "T"
    else
      (1...rope.length).to_a.reverse.each do |i|
        coords = rope[i]
        res[coords.row - min_corner.row][coords.col - min_corner.col] = i.to_s
      end
    end
    res[rope[0].row - min_corner.row][rope[0].col - min_corner.col] = "H"
    res.map(&:join).join("\n")
  end

  def count(sym)
    matrix.values.count(sym)
  end

  def move(dir, steps)
    matrix[rope.last.to_a] = "#"
    return if steps <= 0

    head = rope[0]
    case dir
    when "U"
      head.row -= 1
      min_corner.row -= 1
    when "D"
      head.row += 1
      max_corner.row += 1
    when "L"
      head.col -= 1
      min_corner.col -= 1
    when "R"
      head.col += 1
      max_corner.col += 1
    end
    tail_follow(0)

    move(dir, steps - 1)
  end

  def tail_follow(n)
    return if n > rope.length - 2
    head, tail = rope[n..(n + 1)]
    return if (head.row - tail.row).abs <= 1 && (head.col - tail.col).abs <= 1

    if head.col != tail.col
      tail.col += (head.col - tail.col).positive? ? 1 : -1
    end

    if head.row != tail.row
      tail.row += (head.row - tail.row).positive? ? 1 : -1
    end

    tail_follow(n + 1)
  end
end

Move = Struct.new('Move', :dir, :steps)

class RopeBridge
  attr_accessor :moves

  def initialize(input, direct_input: false)
    @moves = if direct_input
      input
    else
      File.read(input)
    end.split("\n").map do |line|
      dir, steps = line.split
      Move.new(dir, steps.to_i)
    end
  end

  def solve1
    grid = RopeGrid.new(rope_length: 2)
    moves.each { |move| grid.move(move.dir, move.steps) }
    grid.count("#")
  end

  def solve2
    grid = RopeGrid.new(rope_length: 10)
    moves.each { |move| grid.move(move.dir, move.steps) }
    grid.count("#")
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

RopeBridge.run if __FILE__ == $0
