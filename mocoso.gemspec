# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = 'mocoso'
  s.version     = '1.1.0'
  s.summary     = 'A simple stub & mock library'
  s.description = s.summary
  s.authors     = ['Francesco Rodríguez']
  s.email       = ['lrodriguezsanc@gmail.com']
  s.homepage    = 'https://github.com/frodsan/mocoso'
  s.license     = 'MIT'

  s.files = Dir[
    'LICENSE',
    'README.md',
    'lib/**/*.rb',
    '*.gemspec',
    'test/*.*'
  ]

  s.add_development_dependency 'cutest'
end
