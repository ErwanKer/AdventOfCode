require_relative "./cosmic_expansion"

RSpec.describe CosmicExpansion do
  let(:puzzle_example) do
    <<~EXAMPLE
      ....1........
      .........2...
      3............
      .............
      .............
      ........4....
      .5...........
      .##.........6
      ..##.........
      ...##........
      ....##...7...
      8....9.......
    EXAMPLE
  end
  let(:puzzle_input) { File.read("#{File.dirname(__FILE__)}/puzzle") }

  subject { described_class.new(example, direct_input: true) }

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
