require_relative "../lib.rb"
require "active_support/all"
require "progress_bar"
require "byebug"

class HotSpring < Solver
  attr_accessor :input

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @input = lines.map(&:split).map { |a, b| [a, b.split(",").map(&:to_i)] }
  end

  def possible_seqs(seq, start: "")
    return [start] if seq.empty?

    if seq[0] == "?"
      [possible_seqs(seq[1..], start: start + "."), possible_seqs(seq[1..], start: start + "#")].flatten
    else
      [possible_seqs(seq[1..], start: start + seq[0])].flatten
    end
  end

  def possible_arrangement?(seq, con_list)
    seq.split(".").select(&:present?).map(&:size) == con_list
  end

  def count_con_arrangements(seq, con_list)
    p ["count_con_arrangements", seq]
    con_pos = possible_seqs(seq).map { |s| s.split(".").select(&:present?).map(&:size) }
    p ["TEST", con_pos.size]
    con_pos = con_pos.sort_by(&:size).reverse.tally
    con_pos.keys.each do |pos|
      if pos == con_list[...pos.size]
        pos.size.times { con_list.shift }
        return con_pos[pos]
      end
    end
  end

  def count_arrangements2(seq, con_list)
    p ["count_arrangements", seq, con_list]
    seq.split(".").select(&:present?).map do |con_seq|
      res = count_con_arrangements(con_seq, con_list)
      p [con_seq, con_list, res]
      res
    end.reduce(&:*)
  end

  def count_arrangements(seq, con_list)
    remaining_seq = seq
    con_list.each do |con_seq|
      remaining_seq.sub!(/\.*/,"")
      first_spring = remaining_seq.index("#")
      end_seq = remaining_seq[first_spring..].index("?")
      res = remaining_seq[..end_seq].count("#")
      remaining_seq = remaining_seq[end_seq..]
      res
    end.reduce(&:*)
  end

  def solve1
    input.map do |seq, con_list|
      # possible_seqs(seq).select { |s| possible_arrangement?(s, con_list) }.size
      count_arrangements(seq, con_list)
    end.sum
  end

  def solve2
    unfolded = input.map do |seq, con_list|
      [([seq] * 5).join("?"), (con_list * 5).flatten]
    end
    unfolded.map do |seq, con_list|
      res = count_arrangements(seq, con_list)
      p [seq, res]
      res
    end.sum
  end
end

HotSpring.run if __FILE__ == $0
