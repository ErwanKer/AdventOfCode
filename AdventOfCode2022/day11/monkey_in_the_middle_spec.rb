require_relative "./monkey_in_the_middle"

EXAMPLE = <<~EXAMPLE
  Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
      If true: throw to monkey 2
      If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
EXAMPLE

RSpec.describe MonkeyInTheMiddle do
  subject { described_class.new(example, direct_input: true) }
  describe ".solve1" do
    context "puzzle example" do
      let(:example) { EXAMPLE }
      it { expect(subject.solve1).to eq(10605) }
    end
  end
  describe ".money_parse" do
    context "puzzle example" do
      let(:example) { EXAMPLE }
      it "parses the monkeys correctly", :aggregate_failures do
        expect(subject.monkeys.length).to eq(4)
        monkey = subject.monkeys.first
        expect(monkey.items).to eq([79, 98])
        expect(monkey.operation.call(2)).to eq(38)
        expect(monkey.condition.call(46)).to eq(2)
        expect(monkey.condition.call(40)).to eq(3)
      end
    end
  end
end
