require_relative "../lib/processor"

RSpec.describe Processor, "#extract" do
  context "reading only" do
    it "extracts entry" do
      p = Processor.new("spec/fixtures/2015.org", "*** Monday 20 July 2015", "*** Tuesday 21 July 2015")
      expect(p.extract).to eq("\nrelevant stuff\n\nFrom C. S. Lewis, /The Four Loves/, 162:\n\n    quoted stuff\n\nmore relevant stuff\n\n")
    end
    context "citations" do
      it "extracts one" do
        p = Processor.new("spec/fixtures/2015.org", "*** Monday 20 July 2015", "*** Tuesday 21 July 2015")
        expect(p.citations.first).to eq({header: "From C. S. Lewis, /The Four Loves/, 162:", text: "quoted stuff"})
      end
      it "extracts multiple" do
        p = Processor.new("spec/fixtures/2015.org", "*** Tuesday 21 July 2015", "*** Wednesday 22 July 2015")
        expect(p.citations)
          .to eq([
                  {
                   header: "From C. S. Lewis, /The Four Loves/, 162:",
                   text: "quoted stuff"},
                  {
                   header: "From J. R. R. Tolkien, /Tree and Leaf/, 25:",
                   text: "more quoted stuff\non multiple lines\n\nwith line breaks between"}
                 ])
      end
    end
  end

  context "reading and writing" do
    before do
      FileUtils.mkdir("spec/tmp")
    end
    after do
      FileUtils.rm_rf("spec/tmp")
    end

    it "puts link back in file" do
      FileUtils.cp("spec/fixtures/2015.org", "spec/tmp/2015.org")
      expect(File.read("spec/fixtures/2015-with-link.org")).to eq(File.read("spec/tmp/2015.org"))
    end
  end
end
