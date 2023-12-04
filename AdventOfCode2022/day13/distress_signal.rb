require "active_support/all"
require "byebug"

class DistressSignal
  attr_accessor :input

  def initialize(input, direct_input: false)
    @input = (direct_input ? input : File.read(input)).split("\n\n").map do |twolines|
      left, right = twolines.split("\n")
      [JSON.parse(left), JSON.parse(right)]
    end
  end

  def right_order?(left, right)
    hleft, *tleft = left
    hright, *tright = right
    case [hleft, hright]
    in [Integer, Integer]
      hleft < hright || (hleft == hright && (tleft.empty? || (!tright.empty? && right_order?(tleft, tright))))
    in [nil, _]
      true
    in [_, nil]
      false
    in [Array, Array]
      hhleft, *thleft = hleft
      hhright, *thright = hright
      !hright&.empty? && (hleft&.empty? || (right_order?(hhleft, hhright) && (thleft.empty? || (!thright.empty? && right_order?(thleft, thright)))))
    else
      right_order?(Array(hleft), Array(hright))
    end
  end

  def solve1
    #p input.map { |line| right_order?(*line) }
    input.map.with_index.select do |line, index|
      right_order?(*line)
    end.map { |_, i| i + 1}.sum
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

DistressSignal.run if __FILE__ == $0
