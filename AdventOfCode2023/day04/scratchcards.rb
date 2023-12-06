require "active_support/all"
require "byebug"

class Scratchcard
  attr_accessor :cards

  Card = Struct.new(:winners, :numbers)

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @cards = lines.map do |line|
      wins, nums = /.*: ([\d+ ]+) \| ([\d+ ]+)/.match(line).captures
      Card.new(wins.split.map(&:to_i), nums.split.map(&:to_i))
    end
  end

  def solve1
    cards.map do |card|
      wins = (card.winners & card.numbers).size
      wins.positive? ? 2**(wins - 1) : 0
    end.sum
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

Scratchcard.run if __FILE__ == $0
