# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dominatrix/version'

Gem::Specification.new do |spec|
  spec.name          = 'dominatrix'
  spec.version       = Dominatrix::VERSION
  spec.authors       = ['Matt Huggins']
  spec.email         = ['matt.huggins@gmail.com']
  spec.summary       = 'Parse the registered domain name from a URL.'
  spec.description   = 'Parse the registered domain name from a URL.'
  spec.homepage      = 'https://github.com/mhuggins/dominatrix'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
