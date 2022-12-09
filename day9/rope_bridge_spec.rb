require_relative "./rope_bridge"

RSpec.describe RopeBridge do
  subject { described_class.new(example, direct_input: true) }
  describe ".method" do
    context "first simple example" do
      let(:example) { "EXAMPLE" }
      #it { expect(subject.method).to eq(RESULT) }
    end
  end
end
