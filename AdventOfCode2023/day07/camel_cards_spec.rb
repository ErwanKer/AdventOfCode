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
      it { expect(subject.solve2).to eq("???") }
    end
  end
end
