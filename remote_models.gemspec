# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remote_models/version'

Gem::Specification.new do |spec|
  spec.name          = "remote_models"
  spec.version       = RemoteModels::VERSION
  spec.authors       = ["boncri"]
  spec.email         = ["cristiano.boncompagni@intersail.it"]
  spec.summary       = 'Use read-only remote associations with a JSON remote service'
  spec.description   = ''
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
