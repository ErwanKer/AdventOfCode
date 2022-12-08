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
end
