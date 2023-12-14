require_relative "./parabolic_reflector_dish"

RSpec.describe ParabolicReflectorDish do
  let(:puzzle_example) do
    <<~EXAMPLE
      OOOO.#.O.. 10
      OO..#....#  9
      OO..O##..O  8
      O..#.OO...  7
      ........#.  6
      ..#....#.#  5
      ..O..#.O.O  4
      ..O.......  3
      #....###..  2
      #....#....  1
    EXAMPLE
  end
  let(:puzzle_input) { File.read("#{File.dirname(__FILE__)}/puzzle") }

  subject { described_class.new(example, direct_input: true) }

  describe ".solve1" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve1).to eq(136) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve2).to eq("???") }
    end
  end
end
