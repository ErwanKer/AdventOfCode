require_relative "./cosmic_expansion"

RSpec.describe CosmicExpansion do
  let(:puzzle_example) do
    <<~EXAMPLE
      ...#......
      .......#..
      #.........
      ..........
      ......#...
      .#........
      .........#
      ..........
      .......#..
      #...#.....
    EXAMPLE
  end
  let(:puzzle_input) { File.read("#{File.dirname(__FILE__)}/puzzle") }

  subject { described_class.new(example, direct_input: true) }

  describe ".universe" do
    context "puzzle example" do
      let(:example) { puzzle_example }
      let(:expanded_universe) do
        <<~EXAMPLE
          ....#........
          .........#...
          #............
          .............
          .............
          ........#....
          .#...........
          ............#
          .............
          .............
          .........#...
          #....#.......
        EXAMPLE
      end

      it "does to_s correctly" do 
        expect(subject.universe.to_s + "\n").to eq(example)
      end

      it "expands correctly" do
        subject.universe.expand!
        expect(subject.universe.to_s + "\n").to eq(expanded_universe)
      end
    end
  end

  describe ".solve1" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve1).to eq(374) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve2).to eq("???") }
    end
  end
end
