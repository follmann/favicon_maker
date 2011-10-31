module FaviconMaker
  require "mini_magick"
  require 'fileutils'
  
  class Generator
    VERSION = "0.0.1"
    
    ICON_VERSIONS = {
      :apple_114 => ["apple-touch-icon-114x114-precomposed.png", "114x114", "png"],
      :apple_72 => ["apple-touch-icon-72x72-precomposed.png", "72x72", "png"],
      :apple_57 => ["apple-touch-icon-57x57-precomposed.png", "57x57", "png"],
      :apple_pre => ["apple-touch-icon-precomposed.png", "57x57", "png"],
      :apple => ["apple-touch-icon.png", "57x57", "png"],
      :fav_png => ["favicon.png", "16x16", "png"],
      :fav_ico => ["favicon.ico", "16x16", "ico"]
    }
    
    class << self
    
      def create_versions(options={}, &block)
        options = {
          :versions => ICON_VERSIONS.keys,
          :root_dir => File.dirname(__FILE__),
          :input_dir => "favicons",
          :base_image => "favicon_base.png",
          :output_dir => "favicons_output",
          :copy => false
        }.merge(options)
      
        raise ArgumentError unless options[:versions].is_a? Array
        base_path = File.join(options[:root_dir], options[:input_dir])
        input_path = File.join(base_path, options[:base_image])
      
        options[:versions].each do |version|
          version = ICON_VERSIONS[version]
          filename = version[0]
          composed_path = File.join(base_path, filename)
          output_path = File.join(options[:root_dir], options[:output_dir], filename)
        
          created = false
          # check for self composed icon file
          if File.exist?(composed_path)
            if options[:copy]
              FileUtils.cp composed_path, output_path
              created = true
            end
          else
            image = MiniMagick::Image.open(input_path)
            image.resize version[1]
            image.format version[2]
            image.write output_path
            created = true
          end
        
          if block_given? && created
            yield output_path
          end
        end
      end
      
    end
  end
end