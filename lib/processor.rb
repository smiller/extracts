# named using the Sandi Metz rule of "if you can't come up
# with a good name, use a name that will irritate you
# so much you will eventually change it"
class Processor

  def initialize(file_name, begins, ends)
    @file_name = file_name
    @begins = "#{begins}\n"
    @ends = ends
  end

  def extract
    # do not attempt this at home
    # obviously we want streaming here, particularly
    # with the real 2015.org being 1.3Mb
    content = File.read(@file_name)
    content[/#{Regexp.escape(@begins)}(.*?)#{Regexp.escape(@ends)}/m, 1]
  end

  def citations
    citing = false
    extract.split("\n").inject([]) do |citations, line|
      if header_line?(line)
        citations, citing = process_header_line(citations, line)
      elsif citing
        if citation_line?(line)
          citations, citing = process_citation_line(citations, line)
        else
          citations, citing = finish_citation(citations)
        end
      end
      citations
    end
  end

  def header_line?(line)
    line =~ /From.*:/
  end

  def process_header_line(citations, line)
    citations << { header: line, text: [] }
    [citations, true]
  end

  def citation_line?(line)
    line == "" || line =~ /\A    /
  end

  def process_citation_line(citations, line)
    citations.last[:text] << line.sub(/\A    /, "")
    [citations, true]
  end

  def finish_citation(citations)
    citations.last[:text] = citations.last[:text][1..-2].join("\n")
    [citations, false]
  end
end
