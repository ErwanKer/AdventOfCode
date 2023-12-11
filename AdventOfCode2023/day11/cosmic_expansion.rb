require_relative "../lib.rb"
require "active_support/all"
require "byebug"

class CosmicExpansion < Solver
  attr_accessor :input

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @input = lines
  end

  def solve1
    "not implemented yet"
  end

  def solve2
    "not implemented yet"
  end
end

CosmicExpansion.run if __FILE__ == $0
