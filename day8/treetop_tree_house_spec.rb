require_relative "./treetop_tree_house"

RSpec.describe TreetopTreeHouse do
  describe ".set_line_visibility" do
    subject { described_class.new("day8/example").set_line_visibility(vline, line) }

    context "first simple example" do
      let(:vline) { "V123545324V".chars }
      let(:line) { "11235453242".chars.map(&:to_i) }
      it { expect(subject).to eq("V1VVV4V32VV".chars) }
    end
  end

  describe ".calc_scenic_score" do
    subject { described_class.new("day8/example").calc_scenic_score(i, j, line, column) }

    context "first simple example" do
      let(:i) { 2 }
      let(:j) { 1 }
      let(:line) { "25512".chars.map(&:to_i) }
      let(:column) { "35353".chars.map(&:to_i) }
      it { expect(subject).to eq(4) }
    end

    context "second simple example" do
      let(:i) { 2 }
      let(:j) { 3 }
      let(:line) { "33549".chars.map(&:to_i) }
      let(:column) { "35353".chars.map(&:to_i) }
      it { expect(subject).to eq(8) }
    end
  end
end
