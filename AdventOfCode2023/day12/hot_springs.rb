require_relative "../lib.rb"
require "active_support/all"
require "byebug"

class HotSpring < Solver
  attr_accessor :input

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @input = lines.map(&:split).map { |a, b| [a, b.split(",").map(&:to_i)] }
  end

  def possible_seqs(seq, start: "")
    return start if seq.empty?

    if seq[0] == "?"
      [possible_seqs(seq[1..], start: start + "."), possible_seqs(seq[1..], start: start + "#")].flatten
    else
      possible_seqs(seq[1..], start: start + seq[0])
    end
  end

  def possible_arrangement?(seq, con_list)
    seq.split(".").select(&:present?).map(&:size) == con_list
  end

  def solve1
    input.map do |seq, con_list|
      possible_seqs(seq).select { |s| possible_arrangement?(s, con_list) }.size
    end.sum
  end

  def solve2
    "not implemented yet"
  end
end

HotSpring.run if __FILE__ == $0
