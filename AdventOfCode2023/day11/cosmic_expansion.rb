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

  def expand!(expansion: 1)
    empty_rows = df.filter { |row| row.all? { |v| v == "." } }.vectors
    empty_cols = df.filter(:row) { |col| col.all? { |v| v == "." } }.index

    expansion.times { |e| empty_rows.each { |row| df[row + (e.to_f + 1.0) / (expansion + 1.0)] = df[row] } }
    @df = df.reindex_vectors(df.vectors.sort)

    # df.row[col + 0.5] = df.row[col] seems to fail silently, let's transpose
    @df = df.transpose
    expansion.times { |e| empty_cols.each { |col| df[col + (e.to_f + 1.0) / (expansion + 1.0)] = df[col] } }
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

  def expanded_galaxies(expansion)
    gals = galaxies.map { |g| [g, [0]*2] }.to_h
    empty_rows = df.filter { |row| row.all? { |v| v == "." } }.vectors.map { |x| x.to_i - 1 }
    empty_cols = df.filter(:row) { |col| col.all? { |v| v == "." } }.index.map { |x| x.to_i - 1 }
    empty_rows.each do |empty_row|
      gals.keys.each do |row, col|
        gals[[row, col]][0] += expansion if row > empty_row
      end
    end
    empty_cols.each do |empty_col|
      gals.keys.each do |row, col|
        gals[[row, col]][1] += expansion if col > empty_col
      end
    end
    gals.map do |key, expand|
      [key[0] + expand[0], key[1] + expand[1]]
    end
  end
end

class CosmicExpansion < Solver
  attr_accessor :universe, :uni_old

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @uni_old = UniverseMap.new(lines.map(&:chars))
    @universe = UniverseMap.new(lines.map(&:chars))
  end

  def solver(galaxies)
    galaxies.flat_map.with_index do |coords, i|
      other_gals = galaxies[(i+1)..]
      other_gals.map do |xcoords|
        (xcoords[0] - coords[0]).abs + (xcoords[1] - coords[1]).abs
      end
    end.sum
  end

  def solve1
    uni_old.expand!
    solver(uni_old.galaxies)
  end

  def solve2
    solver(universe.expanded_galaxies(1000000 - 1))
  end
end

CosmicExpansion.run if __FILE__ == $0
