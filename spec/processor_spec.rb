require_relative "../lib/processor"

RSpec.describe Processor, "#extract" do
  context "test file" do
    it "retrieves middle bit" do
      p = Processor.new("spec/fixtures/2015.org", "*** Monday 20 July 2015\n", "*** Tuesday 21 July 2015\n")
      expect(p.extract).to eq("\nrelevant stuff\n\nFrom C. S. Lewis, /The Four Loves/, 162:\n\n    quoted stuff\n\nmore relevant stuff\n\n")
    end
  end
end
