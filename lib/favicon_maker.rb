module FaviconMaker
  require "mini_magick"
  require 'fileutils'
  
  class Generator
    VERSION = "0.0.1"
    
    ICON_VERSIONS = {
      :apple_114 => {:filename => "apple-touch-icon-114x114-precomposed.png", :dimensions => "114x114", :format => "png"},
      :apple_72 => {:filename => "apple-touch-icon-72x72-precomposed.png", :dimensions => "72x72", :format => "png"},
      :apple_57 => {:filename => "apple-touch-icon-57x57-precomposed.png", :dimensions => "57x57", :format => "png"},
      :apple_pre => {:filename => "apple-touch-icon-precomposed.png", :dimensions => "57x57", :format => "png"},
      :apple => {:filename => "apple-touch-icon.png", :dimensions => "57x57", :format => "png"},
      :fav_png => {:filename => "favicon.png", :dimensions => "16x16", :format => "png"},
      :fav_ico => {:filename => "favicon.ico", :dimensions => "16x16", :format => "ico"}
    }
    
    class << self
    
      def create_versions(options={}, &block)
        options = {
          :versions => ICON_VERSIONS.keys,
          :custom_versions => {},
          :root_dir => File.dirname(__FILE__),
          :input_dir => "favicons",
          :base_image => "favicon_base.png",
          :output_dir => "favicons_output",
          :copy => false
        }.merge(options)
      
        raise ArgumentError unless options[:versions].is_a? Array
        base_path = File.join(options[:root_dir], options[:input_dir])
        input_path = File.join(base_path, options[:base_image])
        
        icon_versions = ICON_VERSIONS.merge(options[:custom_versions])
        (options[:versions] + options[:custom_versions].keys).uniq.each do |version|
          version = icon_versions[version]
          composed_path = File.join(base_path, version[:filename])
          output_path = File.join(options[:root_dir], options[:output_dir], version[:filename])
        
          created = false
          # check for self composed icon file
          if File.exist?(composed_path)
            if options[:copy]
              FileUtils.cp composed_path, output_path
              created = true
            end
          else
            image = MiniMagick::Image.open(input_path)
            image.resize version[:dimensions]
            image.format version[:format]
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