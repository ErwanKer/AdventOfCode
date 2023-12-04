require "active_support/all"
require "byebug"
require "progress_bar"

Monkey = Struct.new("Monkey", :items, :operation, :condition)

class MonkeyInTheMiddle
  attr_accessor :input, :monkeys

  def initialize(input, direct_input: false)
    @input = (direct_input ? input : File.read(input)).split("\n\n").map{ |s| s.split("\n").map(&:strip) }
    @monkeys = parse_monkeys
  end

  def parse_monkeys
    input.map do |_, start_items, ope, test_cond, test_true, test_false|
      items = start_items.split(":").last.split(",").map(&:to_i)
      operation = lambda { |old| eval(ope.split("= ").last) }
      condition = lambda { |num| num % test_cond.split.last.to_i == 0 ? test_true.split.last.to_i : test_false.split.last.to_i }
      Monkey.new(items, operation, condition)
    end
  end

  def solve1
    monkey_inspections = [0] * monkeys.length
    20.times do
      monkeys.each.with_index do |monkey, k|
        monkey.items.each do |item|
          monkey_inspections[k] += 1
          worry_level = item
          worry_level = monkey.operation.call(worry_level)
          worry_level /= 3
          throw_to = monkey.condition.call(worry_level)
          monkeys[throw_to].items.append(worry_level)
        end
        monkey.items = []
      end
    end
    monkey_boss, monkey_second = monkey_inspections.max(2)
    monkey_boss * monkey_second
  end

  def inspection_numbers(iloops, rounds)
    counts = [0] * monkeys.length
    iloops.tally.each do |iloop, times|
      div, rest = rounds.divmod(iloop.length)
      iloop.each.with_index do |m_idxs, i|
        m_idxs.each do |m_idx|
          counts[m_idx] += div * times
          counts[m_idx] += 1 * times if i < rest
        end
      end
    end
    counts
  end

  def solve2
    @monkeys = parse_monkeys
    items = monkeys.flat_map.with_index { |m, i| m.items.map{ |item| [i, item] } }
    inspection_loops = items.map do |m_idx, item|
      inspectors = []
      new_m_idx = m_idx
      loop do
        if inspectors.last.present? && new_m_idx> inspectors.last.last
          inspectors.last.append(new_m_idx)
        else
          inspectors.append([new_m_idx])
        end
        item = monkeys[new_m_idx].operation.call(item)
        new_m_idx = monkeys[new_m_idx].condition.call(item)
        break if new_m_idx == m_idx
      end
      inspectors
    end
    monkey_inspections = [0] * monkeys.length
    bar = ProgressBar.new(500)
    res = 500.times.map do |round|
      monkeys.each.with_index do |monkey, k|
        monkey_inspections[k] += monkey.items.length
        monkey.items.each do |item|
          worry_level = item
          worry_level = monkey.operation.call(worry_level)
          throw_to = monkey.condition.call(worry_level)
          monkeys[throw_to].items.append(worry_level)
        end
        monkey.items = []
      end
      bar.increment!
      monkey_inspections.dup
    end
    File.write("test.json", 4.times.map{|r| res.map{|mi| mi[r]}}.to_json)
    monkey_boss, monkey_second = monkey_inspections.max(2)
    monkey_boss * monkey_second
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

MonkeyInTheMiddle.run if __FILE__ == $0
