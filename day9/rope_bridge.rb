require "active_support/all"
require "byebug"

class Grid
  attr_accessor :matrix, :nrows, :ncols, :max_row, :max_col
  attr_accessor :head_row, :head_col, :tail_row, :tail_col
  alias_method :to_s, :inspect

  def initialize(estimated_size)
    #estimated_size = 10000
    @nrows, @ncols = [estimated_size] * 2
    @max_row, @max_col = [estimated_size - 1] * 2
    @matrix = estimated_size.times.map { ["."] * estimated_size }
    #@head_row, @tail_row = [@max_row] * 2
    #@head_col, @tail_col = [0] * 2
    @head_row, @head_col, @tail_row, @tail_col = [5000]*4
    #matrix[tail_row][tail_col] = "#"
  end

  def inspect
    res = matrix.map(&:dup)
    res[max_row][0] = "s"
    res[tail_row][tail_col] = "T"
    res[head_row][head_col] = "H"
    res.map(&:join).join("\n")
  end

  def count(sym)
    matrix.map { |row| row.count(sym) }.sum
  end

  def move(dir, steps)
    return if steps <= 0
    case dir
    when "U"
      @head_row -= 1
    when "D"
      @head_row += 1
    when "L"
      @head_col -= 1
    when "R"
      @head_col += 1
    end
    #resize(steps) if head_row > max_row || head_col > max_col
    tail_follow

    move(dir, steps - 1)
  end

  def resize(n)
    @nrows += n
    @ncols += n
    @max_row += n
    @max_col += n
    @matrix = matrix.map { |row| row + ["."] * n } + [(["."] * ncols)] * n
  end

  def tail_follow
    return if (head_row - tail_row).abs <= 1 && (head_col - tail_col).abs <= 1

    if head_col != tail_col
      @tail_col += (head_col - tail_col).positive? ? 1 : -1
    end

    if head_row != tail_row
      @tail_row += (head_row - tail_row).positive? ? 1 : -1
    end

    matrix[tail_row][tail_col] = "#"
  end
end

Coords = Struct.new("Coords", :row, :col)

class Grid2 < Grid
  attr_accessor :rope

  def initialize(estimated_size)
    super(estimated_size)
    @rope = 10.times.map { Coords.new(max_row / 2, max_col / 2) }
  end

  def inspect
    res = matrix.map(&:dup)
    res[max_row / 2][max_row / 2] = "s"
    (1..9).to_a.reverse.each do |i|
      coords = rope[i]
      res[coords.row][coords.col] = i.to_s
    end
    res[rope[0].row][rope[0].col] = "H"
    res.map(&:join).join("\n")
  end

  def move(dir, steps)
    matrix[rope[9].row][rope[9].col] = "#"
    return if steps <= 0

    case dir
    when "U"
      rope[0].row-= 1
    when "D"
      rope[0].row += 1
    when "L"
      rope[0].col -= 1
    when "R"
      rope[0].col += 1
    end
    #resize(steps) if head_row > max_row || head_col > max_col
    tail_follow(0)

    move(dir, steps - 1)
  end

  def tail_follow(n)
    return if n > 8
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
  attr_accessor :moves, :grid, :grid2

  def initialize(input, direct_input: false)
    @moves = if direct_input
      input
    else
      File.read(input)
    end.split("\n").map do |line|
      dir, steps = line.split
      Move.new(dir, steps.to_i)
    end
    @grid = Grid.new(moves.map(&:steps).max)
    @grid2 = Grid2.new(10000)
  end

  def solve1
    moves.each { |move| grid.move(move.dir, move.steps) }
    grid.count("#")
  end

  def solve2
    moves.each { |move| grid2.move(move.dir, move.steps) }
    grid2.count("#")
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
      #puts "=> example solution : #{example_solver.solve1}"
      #puts "=> puzzle solution : #{puzzle_solver.solve1}"
      puts "Solving second part :"
      puts "=> example solution : #{example_solver.solve2}"
      puts "=> puzzle solution : #{puzzle_solver.solve2}"
    end
  end
end

RopeBridge.run if __FILE__ == $0
