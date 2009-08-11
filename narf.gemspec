Gem::Specification.new do |s|
  s.name = %q{narf}
  s.version = "1.0.0"
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ross Andrews"]
  s.date = %q{2009-08-11}
  s.description = %q{Narf is an extremely light-weight web framework}
  s.summary = %q{Narf is an extremely light-weight web framework}
  s.email = %q{randrews@geekfu.org}
  s.files = ["lib/narf.rb", 'Rakefile', 'readme.txt', 
             'example/example.rb', 'example/files/foo.txt', 'example/templates/index.haml', 'example/templates/foo.haml']
  s.has_rdoc = false
  s.homepage = %q{http://github.com/randrews/narf}
  s.rubyforge_project = %q{narf}
 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
