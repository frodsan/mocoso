Gem::Specification.new do |s|
  s.name        = "mocoso"
  s.version     = "1.2.1"
  s.summary     = "A simple stub & mock library."
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez", "Mayn Kjær"]
  s.email       = ["frodsan@me.com", "mayn.kjaer@gmail.com"]
  s.homepage    = "https://github.com/harmoni/mocoso"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest"
end
