require "active_support/all"

class TuningTrouble
  attr_accessor :input

  def initialize(input, direct_input: false)
    @input = (direct_input ? input : File.read(input)).strip
  end

  def find_distinct_seq(seq_size)
    (0..(input.length - seq_size)).each do |i|
      uniq_length = input[i...(i + seq_size)].chars.uniq.length
      return i + seq_size if uniq_length == seq_size
    end
    0 # error value
  end

  def solve1
    find_distinct_seq(4)
  end

  def solve2
    find_distinct_seq(14)
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

TuningTrouble.run if __FILE__ == $0
