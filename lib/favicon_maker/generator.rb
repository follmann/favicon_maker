module FaviconMaker
  require "mini_magick"
  require 'fileutils'

  class Generator

    ICON_VERSIONS = {
      :apple_144 => {:filename => "apple-touch-icon-144x144-precomposed.png", :sizes => "144x144", :format => "png"},
      :apple_120 => {:filename => "apple-touch-icon-120x120-precomposed.png", :sizes => "120x120", :format => "png"},
      :apple_114 => {:filename => "apple-touch-icon-114x114-precomposed.png", :sizes => "114x114", :format => "png"},
      :apple_72 => {:filename => "apple-touch-icon-72x72-precomposed.png", :sizes => "72x72", :format => "png"},
      :apple_57 => {:filename => "apple-touch-icon-57x57-precomposed.png", :sizes => "57x57", :format => "png"},
      :apple_pre => {:filename => "apple-touch-icon-precomposed.png", :sizes => "57x57", :format => "png"},
      :apple => {:filename => "apple-touch-icon.png", :sizes => "57x57", :format => "png"},
      :fav_png => {:filename => "favicon.png", :sizes => "16x16", :format => "png"},
      :fav_ico => {:filename => "favicon.ico", :sizes => "64x64,32x32,24x24,16x16", :format => "ico"}
    }

    IM_VERSION = (`convert --version`).scan(/ImageMagick (\d\.\d\.\d)/).flatten.first
    RECENT_VERSION = "6.8.0"
    COLORSPACE_MIN_VERSION = "6.7.5"

    class << self

      def create_versions(options={}, &block)

        puts "FaviconMaker: WARNING! Your installed ImageMagick version #{IM_VERSION} is not up-to-date and might produce suboptimal output!" if IM_VERSION < RECENT_VERSION

        switch_colorspace = IM_VERSION < COLORSPACE_MIN_VERSION

        colorspace_conv = ["RGB", "sRGB"]
        colorspace_conv.reverse! if switch_colorspace

        is_windows = (RbConfig::CONFIG['host_os'].match /mswin|mingw|cygwin/)

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
        input_file = File.join(base_path, options[:base_image])

        icon_versions = ICON_VERSIONS.merge(options[:custom_versions])
        (options[:versions] + options[:custom_versions].keys).uniq.each do |version|
          version = icon_versions[version]
          sizes = version[:dimensions] || version[:sizes]
          composed_path = File.join(base_path, version[:filename])
          output_path = File.join(options[:root_dir], options[:output_dir])
          output_file = File.join(output_path, version[:filename])

          build_mode = nil
          # check for self composed icon file
          if File.exist?(composed_path) && options[:copy]
            FileUtils.cp composed_path, output_file
            build_mode = :copied
          else
            case version[:format].to_sym
            when :png
              image = MiniMagick::Image.open(input_file)
              image.define "png:include-chunk=none,trns,gama"
              image.colorspace colorspace_conv.first
              image.resize sizes
              image.format "png"
              image.strip
              image.colorspace colorspace_conv.last
              image.write output_file
            when :ico
              ico_cmd = "convert #{input_file} -colorspace #{colorspace_conv.first} "
              escapes = "\\" unless is_windows
              sizes.split(',').sort_by{|s| s.split('x')[0].to_i}.each do |size|
                ico_cmd << "#{escapes}( -clone 0 -colors 256 -resize #{size} #{escapes}) "
              end
              ico_cmd << "-delete 0 -colors 256 -colorspace #{colorspace_conv.last} #{File.join(output_path, version[:filename])}"
              puts `#{ico_cmd}`
            end
            build_mode = :generated
          end

          if block_given?
            yield output_file, build_mode
          end
        end
      end

    end
  end
end
