require_relative "./rope_bridge"

RSpec.describe RopeBridge do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          R 4
          U 4
          L 3
          D 1
          R 4
          D 1
          L 5
          R 2
        EXAMPLE
      end
      it { expect(subject.solve1).to eq(13) }
    end
  end
end
