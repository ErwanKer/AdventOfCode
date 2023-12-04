require_relative "./trebuchet"

RSpec.describe Trebuchet do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          1abc2
          pqr3stu8vwx
          a1b2c3d4e5f
          treb7uchet
        EXAMPLE
      end
      it { expect(subject.solve1).to eq(142) }
    end
  end

  describe ".solve2" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          two1nine
          eightwothree
          abcone2threexyz
          xtwone3four
          4nineeightseven2
          zoneight234
          7pqrstsixteen
        EXAMPLE
      end
      it { expect(subject.solve2).to eq(281) }
    end
  end
end
