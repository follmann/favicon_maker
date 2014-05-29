# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "favicon_maker/version"

Gem::Specification.new do |s|
  s.name        = "favicon_maker"
  s.version     = FaviconMaker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andreas Follmann"]
  #s.email       = [""]
  s.homepage    = "https://github.com/follmann/favicon_maker"
  s.summary     = %q{Create favicon files in various sizes from one or multiple base images}
  s.description = %q{Create favicon files in various sizes from one or multiple base images}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'docile', '~> 1.1'

  s.add_development_dependency 'rspec', '~> 2.14', '>= 2.14.1'
  s.add_development_dependency 'guard-rspec', '~> 1.2'
end
