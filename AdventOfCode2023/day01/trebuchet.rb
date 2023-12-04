require "active_support/all"
require "byebug"

class Trebuchet
  attr_accessor :input

  DIGITS = {
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def initialize(input, direct_input: false)
    @input = (direct_input ? input : File.read(input)).split("\n")
  end

  def first_digit(str)
    str.split("").find { |x| x.in? (0..9).map(&:to_s) }
  end

  def first_digit_extra(str, reverse: false)
    written_digits = reverse ? DIGITS.keys.map(&:reverse) : DIGITS.keys
    digits = written_digits + DIGITS.values
    res = nil
    str.length.times do |i|
      res = digits.find { |d| str[i..].starts_with?(d) }
      break if res
    end
    return res if res.in? DIGITS.values

    res = res.reverse if reverse
    DIGITS[res]
  end

  def solve1
    input.map do |line|
      (first_digit(line) + first_digit(line.reverse)).to_i
    end.sum
  end

  def solve2
    input.map do |line|
      (first_digit_extra(line) + first_digit_extra(line.reverse, reverse: true)).to_i
    end.sum
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

Trebuchet.run if __FILE__ == $0
