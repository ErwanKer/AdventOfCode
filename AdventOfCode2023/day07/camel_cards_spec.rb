require_relative "./camel_cards"

RSpec.describe CamelCard do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          32T3K 765
          T55J5 684
          KK677 28
          KTJJT 220
          QQQJA 483
        EXAMPLE
      end
      it { expect(subject.solve1).to eq(6440) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          32T3K 765
          T55J5 684
          KK677 28
          KTJJT 220
          QQQJA 483
        EXAMPLE
      end

      it { expect(subject.solve2).to eq(5905) }
    end

    context "all individuals cards + joker" do
      let(:example) do
        <<~EXAMPLE
          2J364 2
          2J354 3
        EXAMPLE
      end
      it { expect(subject.solve2).to eq(7) }
    end

    context "with puzzle input" do
      let(:example) { File.read("#{File.dirname(__FILE__)}/puzzle") }

      it "does not give one of the wrong answers" do
        wrong_answers = [251191161, 249916827, 250084338, 250282434, 250531671]
        expect(wrong_answers).not_to include(subject.solve2)
      end
    end
  end
end
