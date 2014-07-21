$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "remote_models/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remote_models"
  s.version     = RemoteModels::VERSION
  s.authors     = ["INTERSAIL"]
  s.email       = ["info@intersail.it"]
  s.homepage    = "http://www.intersail.it"
  s.summary     = "Use read-only remote associations with a JSON remote service"
  s.description = "Use read-only remote associations with a JSON remote service"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mocha"
  s.add_dependency "activesupport"
end
