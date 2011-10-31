# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "favicon_maker"
  s.version     = FaviconMaker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andreas Follmann"]
  #s.email       = [""]
  s.homepage    = "https://github.com/follmann/favicon_maker"
  s.summary     = %q{Create favicon files in various sizes from a base image}
  s.description = %q{Create favicon files in various sizes from a base image}

  s.rubyforge_project = "favicon_maker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency("mini_magick", ["~> 3.0"])
end