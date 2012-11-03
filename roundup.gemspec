# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "roundup"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = "2012-11-04"
  s.description = "Clean periodic snaphots while keeping files that matter"
  s.email = ["deepfryed@gmail.com"]
  s.files = ["test/helper.rb", "test/test_roundup.rb", "lib/roundup.rb", "README.md", "CHANGELOG"]
  s.homepage = "http://github.com/deepfryed/roundup"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A file system cleaner for periodic snapshots"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
