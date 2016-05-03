#
require './lib/venduitz/version'

#
Gem::Specification.new do |s|
  s.name = 'venduitz'
  s.version = Venduitz.version

  s.summary = ''
  s.description = ''

  s.author = 'Gabriel Corado'
  s.email = 'gabrielcorado@mail.com'
  s.homepage = 'http://github.com/gabrielcorado/venduitz'

  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  # Dependencies
  # s.add_dependency 'concurrent-ruby', '~> 1.0'
  # s.add_dependency 'docker-api', '~> 1.26'
  s.add_dependency 'multi_json'
  s.add_dependency 'oj'

  # Development depencies
  s.add_development_dependency 'rspec', '~> 3.0'
end
