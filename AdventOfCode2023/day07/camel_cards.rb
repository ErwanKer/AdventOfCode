require "active_support/all"
require "byebug"

class CamelCard
  attr_accessor :hands

  class Card
    attr_reader :index, :letter

    ORDER = "23456789TJQKA".chars

    def initialize(letter)
      @letter = letter
      @index = ORDER.index(letter)
    end

    def <=>(other)
      @index <=> other.index
    end

    def ==(other)
      @letter == other.letter
    end

    def inspect
      "#<Card: #{@letter}>"
    end
  end

  class Hand
    attr_reader :hand

    TYPE_ORDER = ["High Card", "One pair", "Two pair", "Three of a kind", "Full house", "Four of a kind", "Five of a kind"]

    def initialize(five_letters)
      @hand = five_letters.chars.map { |letter| Card.new(letter) }
    end

    def index
      @index ||= TYPE_ORDER.index(type)
    end

    def type
      @type ||= begin
        card_nums = hand.map(&:letter).tally.values.sort.reverse
        case card_nums
        in [5]
          "Five of a kind"
        in [4, 1]
          "Four of a kind"
        in [3, 2]
          "Full house"
        in [3, 1, 1]
          "Three of a kind"
        in [2, 2, 1]
          "Two pair"
        in [2, 1, 1, 1]
          "One pair"
        else
          "High Card"
        end
      end
    end

    def <=>(other)
      order = index <=> other.index
      order.zero? ? hand <=> other.hand : order
    end

    def inspect
      "#<Hand: #{hand.map(&:letter).join("")}>"
    end
  end

  def initialize(input, direct_input: false)
    lines = (direct_input ? input : File.read(input)).split("\n")
    @hands = lines.map do |line|
      hand, bid = line.split
      [Hand.new(hand), bid.to_i]
    end
  end

  def solve1
    hands.sort.map.with_index do |(hand, bid), index|
      (index + 1) * bid
    end.sum
  end

  def solve2
    "not implemented yet"
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

CamelCard.run if __FILE__ == $0
