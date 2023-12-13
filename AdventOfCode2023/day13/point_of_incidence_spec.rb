require_relative "./point_of_incidence"

RSpec.describe PointOfIncidence do
  let(:puzzle_example) do
    <<~EXAMPLE
      #.##..##.
      ..#.##.#.
      ##......#
      ##......#
      ..#.##.#.
      ..##..##.
      #.#.##.#.
      
      #...##..#
      #....#..#
      ..##..###
      #####.##.
      #####.##.
      ..##..###
      #....#..#
    EXAMPLE
  end
  let(:puzzle_input) { File.read("#{File.dirname(__FILE__)}/puzzle") }

  subject { described_class.new(example, direct_input: true) }

  describe ".solve1" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve1).to eq(405) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve2).to eq(400) }
    end
  end
end
