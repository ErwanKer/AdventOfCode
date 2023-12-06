require "active_support/all"
require "progress_bar"
require "byebug"

class IfYouGiveASeedAFertilizer
  attr_accessor :seeds, :maps

  class Mapping
    Range = Struct.new(:dst, :end)

    def initialize(lines)
      @src_idx = []
      @mapping = {}
      lines.each do |line|
        dst, src, len = line.split.map(&:to_i)
        @src_idx.append(src)
        @mapping[src] = Range.new(dst, src + len)
      end
      @src_idx.sort!
    end

    def [](key)
      possible_mapping_idx = @src_idx.bsearch_index { |val| val > key } || @src_idx.size
      return key unless possible_mapping_idx.positive?

      src = @src_idx[possible_mapping_idx - 1]
      range = @mapping[src]
      if key < range.end
        range.dst + (key - src)
      else
        key
      end
    end
  end

  Map = Struct.new(:source, :destination, :mapping)

  def initialize(input, direct_input: false)
    sections = (direct_input ? input : File.read(input)).split("\n\n")
    @seeds = sections.shift.split(":").last.split.map(&:to_i)
    @maps = sections.map do |section|
      lines = section.split("\n")
      src, dst = lines.shift.split.first.split("-to-")
      [src, Map.new(src, dst, Mapping.new(lines))]
    end.to_h
  end

  def location(seed)
    curr_map = maps["seed"]
    curr_val = seed
    while curr_map.destination != "location"
      curr_val = curr_map.mapping[curr_val]
      curr_map = maps[curr_map.destination]
    end
    curr_map.mapping[curr_val]
  end

  def solve1
    seeds.map { |seed| location(seed) }.min
  end

  def solve2
    bar = ProgressBar.new(seeds.each_slice(2).map(&:last).sum)
    min_loc = nil
    seeds.each_slice(2) do |start, length|
      (start..(start + length)).each do |seed|
        min_loc = [min_loc, location(seed)].compact.min
        bar.increment!
      end
    end
    min_loc
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

IfYouGiveASeedAFertilizer.run if __FILE__ == $0
