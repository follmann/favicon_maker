module FaviconMaker
  
  libdir = File.dirname(__FILE__)
  $LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
  
  # Auto-load modules on-demand
  autoload :Generator, "favicon_maker/generator"
  
end