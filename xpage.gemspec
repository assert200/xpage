Gem::Specification.new do |s|
  s.name        = 'xpage'
  s.version     = '0.4.2'
  s.add_runtime_dependency "retryer", "= 0.4.2"
  s.add_runtime_dependency "selenium-webdriver", ">= 2.50"
  s.date        = '2016-09-21'
  s.summary     = "xpage"
  s.description = "Xpath methods for page objects"
  s.authors     = ["James Barker"]
  s.email       = 'jarbarker@gmail.com'
  s.files       = ["lib/xpage.rb"]
  s.homepage    =
    'http://github.com/assert200/xpage'
  s.license       = 'MIT'
end
