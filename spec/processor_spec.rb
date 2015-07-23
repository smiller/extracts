require_relative "../lib/processor"

RSpec.describe Processor, "#extract" do
  context "test file" do
    it "retrieves middle bit" do
      p = Processor.new("spec/fixtures/2015.org", "*** Monday 20 July 2015", "*** Tuesday 21 July 2015")
      expect(p.extract).to eq("\nrelevant stuff\n\nFrom C. S. Lewis, /The Four Loves/, 162:\n\n    quoted stuff\n\nmore relevant stuff\n\n")
    end
    it "puts link back in file" do
      File.delete("spec/tmp/2015.org") if File.exist?("spec/tmp/2015.org")
      FileUtils.cp("spec/fixtures/2015.org", "spec/tmp/2015.org")
      expect(File.read("spec/fixtures/2015-with-link.org")).to eq(File.read("spec/tmp/2015.org"))
      File.delete("spec/tmp/2015.org")
    end
  end
end
