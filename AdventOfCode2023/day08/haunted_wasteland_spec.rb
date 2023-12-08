require_relative "./haunted_wasteland"

RSpec.describe HauntedWasteland do
  let(:puzzle_example) do
    <<~EXAMPLE
      RL
      
      AAA = (BBB, CCC)
      BBB = (DDD, EEE)
      CCC = (ZZZ, GGG)
      DDD = (DDD, DDD)
      EEE = (EEE, EEE)
      GGG = (GGG, GGG)
      ZZZ = (ZZZ, ZZZ)
    EXAMPLE
  end
  let(:puzzle_input) { File.read("#{File.dirname(__FILE__)}/puzzle") }

  subject { described_class.new(example, direct_input: true) }

  describe ".solve1" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve1).to eq(6) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) { puzzle_example }

      it { expect(subject.solve2).to eq("???") }
    end
  end
end
