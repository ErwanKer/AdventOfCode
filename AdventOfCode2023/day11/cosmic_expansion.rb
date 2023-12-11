require_relative "../lib.rb"
require "active_support/all"
require "daru"
require "byebug"

class UniverseMap
  attr_accessor :df

  def initialize(df_input)
    cols = (1..df_input[0].size).map(&:to_f)
    rows = (1..df_input.size).map(&:to_f)
    @df = Daru::DataFrame.new(df_input, order: cols, index: rows)
  end

  def to_s
    df.map{ |v| v.to_a.join("") }.join("\n")
  end

  def expand!
    empty_rows = df.filter { |row| row.all? { |v| v == "." } }.vectors
    empty_cols = df.filter(:row) { |col| col.all? { |v| v == "." } }.index

    empty_rows.each { |row| df[row + 0.5] = df[row] }
    @df = df.reindex_vectors(df.vectors.sort)

    # df.row[col + 0.5] = df.row[col] seems to fail silently, let's transpose
    @df = df.transpose
    empty_cols.each { |col| df[col + 0.5] = df[col] }
    @df = df.reindex_vectors(df.vectors.sort)
    @df = df.transpose
  end

  def galaxies
    df.map.with_index do |row, i|
      row.map.with_index do |v, j|
        [i, j] if v == "#"
      end.compact
    end.select(&:present?).flatten(1).sort
  end
end

class CosmicExpansion < Solver
  attr_accessor :universe

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @universe = UniverseMap.new(lines.map(&:chars))
  end

  def solve1
    universe.expand!
    gals = universe.galaxies
    gals.flat_map.with_index do |coords, i|
      other_gals = gals[(i+1)..]
      other_gals.map do |xcoords|
        (xcoords[0] - coords[0]).abs + (xcoords[1] - coords[1]).abs
      end
    end.sum
  end

  def solve2
    "not implemented yet"
  end
end

CosmicExpansion.run if __FILE__ == $0
