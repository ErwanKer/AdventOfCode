require_relative "./wait_for_it"

RSpec.describe WaitForIt do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          Time:      7  15   30
          Distance:  9  40  200
        EXAMPLE
      end
      it { expect(subject.solve1).to eq(288) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          Time:      7  15   30
          Distance:  9  40  200
        EXAMPLE
      end
      it { expect(subject.solve2).to eq(71503) }
    end
  end
end
