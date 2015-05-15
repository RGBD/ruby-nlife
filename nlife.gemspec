require_relative './lib/nlife/version'

Gem::Specification.new do |s|
  s.name        = 'nlife'
  s.version     = NLife::VERSION
  s.licenses    = ['LGPL-3.0']
  s.authors     = ["Oleg Zubchenko"]
  s.email       = 'RedGreenBlueDiamond@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/nlife'
  s.summary     = "Generalized Game of Life"
  s.description = "Customizable Game of Life with ncurses viewer"
  s.files       = Dir["lib/**/*.rb"] + Dir["bin/*"] + Dir["*.md"] + 
                  Dir["*.gemspec"]
  s.executables << 'nlife'

  s.add_runtime_dependency 'curses', '~> 1.0', '>= 1.0.1'
  s.add_runtime_dependency 'narray', '~>0.6.1'
  s.add_runtime_dependency 'numru-misc', '~>0.1.2'
  s.add_runtime_dependency 'ruby-fftw3', '~>0.4.2'
end
