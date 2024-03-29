require_relative "../lib.rb"
require "active_support/all"
require "byebug"

class PointOfIncidence < Solver
  attr_accessor :patterns

  def initialize(input, direct_input: false)
    patterns = (direct_input ? input : File.read(input)).split("\n\n")
    @patterns = patterns.map { |p| p.split("\n").map(&:chars) }
  end

  def is_reflection?(h_index, pattern)
    dist = 0
    while pattern[h_index - dist] == pattern[h_index + 1 + dist] && dist <= h_index
      dist += 1
    end

    dist >= 1 && (dist > h_index || h_index + dist >= (pattern.size - 1))
  end

  def find_h_reflection_number(pattern)
    pattern.size.times { |h_index| return h_index + 1 if is_reflection?(h_index, pattern) }

    nil
  end

  def find_reflection_transformed_number(pattern)
    find_h_reflection_number(pattern.transpose) || find_h_reflection_number(pattern) * 100
  end

  def distance(l1, l2)
    l1.zip(l2).count { |a, b| a != b } rescue l1.size
  end

  def sis_reflection?(h_index, pattern)
    dist = 0
    found_smudge = false
    while dist <= h_index
      l1 = pattern[h_index - dist]
      l2 = pattern[h_index + 1 + dist]
      break if l1 != l2 && (found_smudge || (d12 = distance(l1, l2)) > 1)

      found_smudge = true if d12 == 1
      dist += 1
    end

    found_smudge && dist >= 1 && (dist > h_index || h_index + dist >= (pattern.size - 1))
  end

  def sfind_h_reflection_number(pattern)
    pattern.size.times { |h_index| return h_index + 1 if sis_reflection?(h_index, pattern) }

    nil
  end

  def sfind_reflection_transformed_number(pattern)
    sfind_h_reflection_number(pattern.transpose) || sfind_h_reflection_number(pattern) * 100
  end

  def print_reflections
    patterns.each do |pattern|
      byebug
      h_index = find_h_reflection_number(pattern)
      horizontal = true
      unless h_index
        horizontal = false
        pattern = pattern.transpose
        h_index = find_h_reflection_number(pattern)
      end
      v_version = pattern.transpose
      numbers = (1..pattern.size).to_a
      indicators = [" "] * pattern.size
      indicators[h_index] = "^"
      indicators[h_index - 1] = "v"
      printable = ([numbers, indicators] + v_version + [indicators, numbers]).transpose
      puts printable.map(&:join).join("\n")
      puts "Solution #{h_index} for #{horizontal ? 'horizontal' : 'vertical'} reflection"
      puts
    end
  end

  def solve1
    #print_reflections
    patterns.map do |pattern|
      find_reflection_transformed_number(pattern)
    end.sum
  end

  def solve2
    patterns.map do |pattern|
      sfind_reflection_transformed_number(pattern)
    end.sum
  end
end

PointOfIncidence.run if __FILE__ == $0
