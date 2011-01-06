# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cdr-fetcher}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Carl Hicks"]
  s.date = %q{2010-07-15}
  s.description = %q{A gem for fetching CDR data from a remote system via SSH/SFTP.  Supports fetching all files, or a delta from a given offset.}
  s.email = %q{carl.hicks@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "cdr-fetcher.gemspec",
     "lib/cdr-fetcher.rb",
     "test/helper.rb",
     "test/test_cdr-fetcher.rb"
  ]
  s.homepage = %q{http://github.com/chicks/cdr-fetcher}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A gem for fetching CDR's from a remote system.}
  s.test_files = [
    "test/helper.rb",
     "test/test_cdr-fetcher.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<net-sftp>, [">= 0"])
      s.add_runtime_dependency(%q<net-ssh>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<net-sftp>, [">= 0"])
      s.add_dependency(%q<net-ssh>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<net-sftp>, [">= 0"])
    s.add_dependency(%q<net-ssh>, [">= 0"])
  end
end

