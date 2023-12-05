require_relative "./gear_ratios"

RSpec.describe GearRatio do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          467..114..
          ...*......
          ..35..633.
          ......#...
          617*......
          .....+.58.
          ..592.....
          ......755.
          ...$.*....
          .664.598..
        EXAMPLE
      end
      it { expect(subject.solve1).to eq(4361) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          467..114..
          ...*......
          ..35..633.
          ......#...
          617*......
          .....+.58.
          ..592.....
          ......755.
          ...$.*....
          .664.598..
        EXAMPLE
      end
      it { expect(subject.solve2).to eq(467835) }
    end
  end
end
