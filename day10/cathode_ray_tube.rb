require "active_support/all"
require "byebug"

class CathodeRayTube
  attr_accessor :input

  def initialize(input, direct_input: false)
    @input = (direct_input ? input : File.read(input)).split("\n")
  end

  def solve1
    cycles = 1
    register_value = 1
    signal_strengths = {}
    next_to_record = 20
    input.each do |line|
      case line.split
      in ["noop"]
        cycles += 1
        record = cycles == next_to_record
      in "addx", num
        cycles += 2
        register_value += num.to_i
        record = cycles.in? [next_to_record, next_to_record + 1]
      end
      if record
        signal_strengths[next_to_record] = register_value
        signal_strengths[next_to_record] -= num.to_i if (cycles % 10) == 1
        signal_strengths[next_to_record] *= next_to_record
        next_to_record += 40
      end
    end
    signal_strengths.values.sum
  end

  def pixel(register, position)
    if [position - 1, 0].max <= register && register <= [position + 1, 40].min
      "#"
    else
      "."
    end
  end

  def solve2
    crt = [""]
    cycles = 0
    register_value = 1
    input.each do |line|
      case line.split
      in ["noop"]
        crt[-1] += pixel(register_value, cycles % 40)
        cycles += 1
      in "addx", num
        crt[-1] += pixel(register_value, cycles % 40)
        cycles += 1
        crt.append("") if (cycles % 40 == 0)
        crt[-1] += pixel(register_value, cycles % 40)
        cycles += 1
        register_value += num.to_i
      end
      crt.append("") if (cycles % 40 == 0)
    end
    crt.join("\n")
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
      puts "=> example solution : \n#{example_solver.solve2}"
      puts "=> puzzle solution : \n#{puzzle_solver.solve2}"
    end
  end
end

CathodeRayTube.run if __FILE__ == $0
