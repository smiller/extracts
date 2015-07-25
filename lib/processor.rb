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
    matches = (/\n(From[^\n]*:)\n\n(.*)\n\n[^\n| ]/).match(extract)
    if matches
      [{header: matches[1], text: matches[2].sub(/\A    /, "")}]
    end
  end
end
