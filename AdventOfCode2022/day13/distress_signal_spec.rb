require_relative "./distress_signal"

RSpec.describe DistressSignal do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) do
        <<~EXAMPLE
          [1,1,3,1,1]
          [1,1,5,1,1]
          
          [[1],[2,3,4]]
          [[1],4]
          
          [9]
          [[8,7,6]]
          
          [[4,4],4,4]
          [[4,4],4,4,4]
          
          [7,7,7,7]
          [7,7,7]
          
          []
          [3]
          
          [[[]]]
          [[]]
          
          [1,[2,[3,[4,[5,6,7]]]],8,9]
          [1,[2,[3,[4,[5,6,0]]]],8,9]
        EXAMPLE
      end
      it { expect(subject.solve1).to eq(13) }
    end
  end
end
