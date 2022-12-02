puzzle_input = File.read(ARGV[0]).split("\n")

decode = { "A" => "R", "B" => "P", "C" => "S", "X" => "R", "Y" => "P", "Z" => "S" }

def round_score(p1, p2)
  shape_score = { "R" => 1, "P" => 2, "S" => 3 }
  winners = { "R" => "S", "P" => "R", "S" => "P" }
  outcome_score = 0
  if p1 == p2
    outcome_score = 3
  elsif winners[p2] == p1
    outcome_score = 6
  end
  shape_score[p2] + outcome_score
end

def round_score2(p1, p2)
  shape_score = { "R" => 1, "P" => 2, "S" => 3 }
  winners = { "R" => "S", "P" => "R", "S" => "P" }.invert
  loosers = winners.keys.zip(winners.values.rotate).to_h
  draws = loosers.keys.zip(loosers.values.rotate).to_h
  case p2
    when "X"
      0 + shape_score[loosers[p1]]
    when "Y"
      3 + shape_score[draws[p1]]
    when "Z"
      6 + shape_score[winners[p1]]
  end
end

total = 0
puzzle_input.each do |line|
  p1, p2 = line.split
  total += round_score(decode[p1], decode[p2])
end

p total

total = puzzle_input.map do |line|
  p1, p2 = line.split
  round_score2(decode[p1], p2)
end.sum

p total
