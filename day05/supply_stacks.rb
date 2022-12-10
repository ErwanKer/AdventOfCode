require "active_support/all"

class SupplyStack
  attr_accessor :stacks, :moves, :stack_coords

  Move = Struct.new('Move', :n_crates, :from, :to)

  def initialize(input_filename)
    @stacks, @moves = File.read(input_filename).split("\n\n").map{ |s| s.split("\n") }
    parse_stacks
    parse_moves
  end

  def parse_moves
    @moves = moves.map do |line|
      move = line.split.map(&:to_i).select(&:positive?)
      Move.new(*move)
    end
  end

  def parse_stacks
    @stack_coords = stacks.last.chars.map(&:to_i).map.with_index.select{|c,i| c > 0}.to_h.invert
    new_stacks = []
    (stack_coords.count + 1).times { new_stacks.append([]) } # let's be 1-indexed instead of 0
    stacks[...-1].reverse.each do |line|
      crates = line.chars.map.with_index.select{|c,i| c.in? "A".."Z"}
      crates.each do |type, stack|
        new_stacks[stack_coords[stack]].append(type)
      end
    end
    @stacks = new_stacks
  end

  def print_stacks(pstacks)
    length = pstacks.count
    height = pstacks.map(&:count).max
    res = ""
    (0...height).reverse_each do |h|
      (1..length).each do |l|
        el = pstacks.dig(l, h)
        res += el.nil? ? "     " : " [#{el}] "
      end
      res += "\n"
    end
    (1...length).each { |i| res += "  #{i}  " }
    puts res
  end

  def solve1
    res_stacks = stacks.deep_dup
    moves.each do |move|
      move.n_crates.times do
        res_stacks[move.to].append(res_stacks[move.from].pop)
      end
    end
    res_stacks.map(&:last).compact.join
  end

  def solve2
    res_stacks = stacks.deep_dup
    moves.each do |move|
      res_stacks[move.to].concat(res_stacks[move.from].pop(move.n_crates))
    end
    res_stacks.map(&:last).compact.join
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

SupplyStack.run if __FILE__ == $0
