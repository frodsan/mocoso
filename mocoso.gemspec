Gem::Specification.new do |s|
  s.name        = "mocoso"
  s.version     = "1.2.2"
  s.summary     = "A simple stub & mock library."
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez"]
  s.email       = ["frodsan@protonmail.ch"]
  s.homepage    = "https://github.com/harmoni/mocoso"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest", "1.2.2"
end
