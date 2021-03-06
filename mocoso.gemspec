Gem::Specification.new do |s|
  s.name        = "mocoso"
  s.version     = "1.2.3"
  s.summary     = "A simple stub & mock library."
  s.description = s.summary
  s.author      = "Francesco Rodríguez"
  s.email       = "hello@frodsan.com"
  s.homepage    = "https://github.com/frodsan/mocoso"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.add_development_dependency "cutest", "~> 1.2"
  s.add_development_dependency "rake", "~> 11.0"
  s.add_development_dependency "rubocop", "~> 0.39"
end
