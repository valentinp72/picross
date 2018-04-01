Gem::Specification.new do |s|

  s.name = 'rubycross'
  s.version = '0.0.2'
  s.date = '2018-04-01'
  s.summary = 'Rubycross !'
  s.description = 'A picross game'
  s.authors = ['nobody']
  s.email = 'myself@my.com'
  s.files = Dir["{bin/lib}/**/*"]
  s.homepage = 'https://picross.vlntn.pw/'
  s.license = 'MIT'
  s.executables << 'rubycross'
  s.add_runtime_dependency "gtk3", "~> 3.2", ">= 3.2.1"

end
