$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "routing_concerns/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "routing_concerns"
  s.version     = RoutingConcerns::VERSION
  s.authors     = ["David Heinemeier Hansson"]
  s.email       = ["david@heinemeierhansson.com"]
  s.summary     = "Routing concerns for Action Pack"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "actionpack", ">= 3.2.0"
  s.add_dependency "activemodel", ">= 3.2.0"
  s.add_dependency "railties", ">= 3.2.0"

  s.add_development_dependency "rake"
end
