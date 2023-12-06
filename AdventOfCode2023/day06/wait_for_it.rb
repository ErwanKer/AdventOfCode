require "active_support/all"
require "byebug"

class WaitForIt
  attr_accessor :races, :mega_race

  Race = Struct.new(:time, :distance)

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    times = lines[0].split[1..]
    distances = lines[1].split[1..]
    @races = times.zip(distances).map { |t, d| Race.new(time: t.to_i, distance: d.to_i) }
    @mega_race = Race.new(*lines.map { |line| line.split(":")[1].tr(" ", "").to_i })
  end

  def race_outcomes(race)
    (0..race.time).map do |button_press_time|
      remaining_time = race.time - button_press_time
      remaining_time * button_press_time
    end
  end

  def solve1
    races.map do |race|
      race_outcomes(race).select { |outcome| outcome > race.distance }.size
    end.reduce(&:*)
  end

  def solve2
    race_outcomes(mega_race).select { |outcome| outcome > mega_race.distance }.size
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

WaitForIt.run if __FILE__ == $0
