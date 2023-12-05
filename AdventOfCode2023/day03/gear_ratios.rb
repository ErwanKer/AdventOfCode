require "active_support/all"
require "byebug"

class GearRatio
  attr_accessor :input, :line_offset, :max_len

  def initialize(input, direct_input: false)
    @input = (direct_input ? input : File.read(input))
    @line_offset = @input.index("\n") + 1
    @max_len = @input.length
  end

  def sanitized(coord)
    [[0, coord].max, max_len].min
  end

  def get_section(x, y)
    input[sanitized(x)...sanitized(y)] || ""
  end

  def get_surround(x, y)
    get_section(x - line_offset, y - line_offset) + get_section(x, y) + get_section(x + line_offset, y + line_offset)
  end

  def solve1
    numbers = []
    input.scan(/\d+/) do |num|
      numbers << [num, Regexp.last_match.offset(0)]
    end
    numbers.select! do |num, positions|
      x, y = positions
      x -= 1
      y += 1
      remains = get_surround(x, y).gsub(num, "").gsub(".", "")
      remains.present?
    end
    numbers.map(&:first).map(&:to_i).sum
  end

  def solve2
    numbers = []
    input.scan(/\d+/) do |num|
      numbers << [num, Regexp.last_match.offset(0)]
    end
    gears = Hash.new { |h,k| h[k] = [] }
    numbers.each do |num, positions|
      x, y = positions
      x -= 1
      y += 1
      [
        [x - line_offset, y - line_offset],
        [x, y],
        [x + line_offset, y + line_offset]
      ].each do |z, w|
        gear_local_pos = get_section(z, w).index("*")
        gears[z + gear_local_pos].append(num.to_i) if gear_local_pos
      end
    end
    gears.values.map do |vals|
      vals[0] * (vals[1] || 0)
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

GearRatio.run if __FILE__ == $0
