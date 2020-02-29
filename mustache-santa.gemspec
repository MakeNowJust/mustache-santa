# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mustache/santa/version'

Gem::Specification.new do |spec|
  spec.name          = 'mustache-santa'
  spec.version       = Mustache::Santa::VERSION
  spec.authors       = ['TSUYUSATO Kitsune']
  spec.email         = ['make.just.on@gmail.com']

  spec.summary       = 'Mustache syntax extension to support parameters.'
  spec.description   = 'Mustache::Santa extends Mustache syntax to support parameters.'
  spec.homepage      = 'https://github.com/MakeNowJust/mustache-santa'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mustache', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop'
end
