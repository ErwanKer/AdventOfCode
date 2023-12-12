require_relative "./hot_springs"

RSpec.describe HotSpring do
  let(:puzzle_example) do
    <<~EXAMPLE
      ?###???????? 3,2,1
      .###.##.#...
      .###.##..#..
      .###.##...#.
      .###.##....#
      .###..##.#..
      .###..##..#.
      .###..##...#
      .###...##.#.
      .###...##..#
      .###....##.#
    EXAMPLE
  end
  let(:puzzle_input) { File.read("#{File.dirname(__FILE__)}/puzzle") }

  subject { described_class.new(example, direct_input: true) }

  describe ".solve1" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve1).to eq(21) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve2).to eq("???") }
    end
  end
end
