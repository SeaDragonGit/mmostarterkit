# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mmostarterkit/version'

Gem::Specification.new do |spec|
  spec.name          = 'mmostarterkit'
  spec.version       = Mmostarterkit::VERSION
  spec.authors       = ['SeaDragon']
  spec.email         = ['public@seadragonunity.com']
  spec.summary       = %q{MMOStarterKit game lobby.}
  spec.description   = %q{Implement game lobby and statistics controllers as well as matchmaking.}
  spec.homepage      = 'http://seadragonunity.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
