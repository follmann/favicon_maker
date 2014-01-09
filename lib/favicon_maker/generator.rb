module FaviconMaker
  require "mini_magick"
  require 'fileutils'
  require 'pathname'

  class Generator

    ICON_VERSION_DEFINITIONS = {
      :apple_152  => { :filename => "apple-touch-icon-152x152-precomposed.png", :sizes => "152x152",  :format => "png" },
      :apple_144  => { :filename => "apple-touch-icon-144x144-precomposed.png", :sizes => "144x144",  :format => "png" },
      :apple_120  => { :filename => "apple-touch-icon-120x120-precomposed.png", :sizes => "120x120",  :format => "png" },
      :apple_114  => { :filename => "apple-touch-icon-114x114-precomposed.png", :sizes => "114x114",  :format => "png" },
      :apple_76   => { :filename => "apple-touch-icon-76x76-precomposed.png",   :sizes => "76x76",    :format => "png" },
      :apple_72   => { :filename => "apple-touch-icon-72x72-precomposed.png",   :sizes => "72x72",    :format => "png" },
      :apple_60   => { :filename => "apple-touch-icon-60x60-precomposed.png",   :sizes => "60x60",    :format => "png" },
      :apple_57   => { :filename => "apple-touch-icon-57x57-precomposed.png",   :sizes => "57x57",    :format => "png" },
      :apple_pre  => { :filename => "apple-touch-icon-precomposed.png",         :sizes => "57x57",    :format => "png" },
      :apple      => { :filename => "apple-touch-icon.png",                     :sizes => "57x57",    :format => "png" },
      :fav_196    => { :filename => "favicon-196x196.png",                      :sizes => "196x196",  :format => "png" },
      :fav_160    => { :filename => "favicon-160x160.png",                      :sizes => "160x160",  :format => "png" },
      :fav_96     => { :filename => "favicon-96x96.png",                        :sizes => "96x96",    :format => "png" },
      :fav_32     => { :filename => "favicon-32x32.png",                        :sizes => "32x32",    :format => "png" },
      :fav_16     => { :filename => "favicon-16x16.png",                        :sizes => "16x16",    :format => "png" },
      :fav_png    => { :filename => "favicon.png",                              :sizes => "16x16",    :format => "png" },
      :fav_ico    => { :filename => "favicon.ico",                              :sizes => "64x64,32x32,24x24,16x16", :format => "ico" },
      :mstile_144 => { :filename => "mstile-144x144",                           :sizes => "144x144",  :format => "png" }
    }

    DEFAULT_OPTIONS = {
      :versions         => ICON_VERSION_DEFINITIONS.keys,
      :custom_versions  => {},
      :root_dir         => File.dirname(__FILE__),
      :input_dir        => "favicons",
      :base_image       => "favicon_base.png",
      :output_dir       => "favicons_output",
      :copy             => false
    }

    IM_VERSION                    = (`convert --version`).scan(/ImageMagick (\d\.\d\.\d)/).flatten.first
    RECENT_VERSION                = "6.8.0"
    COLORSPACE_MIN_VERSION        = "6.7.5"
    COLORSPACE_IN, COLORSPACE_OUT = *(IM_VERSION < COLORSPACE_MIN_VERSION ? ["sRGB", "RGB"] : ["RGB", "sRGB"])

    class << self

      def create_versions(options={}, &block)
        print_image_magick_warning  if IM_VERSION < RECENT_VERSION

        options = DEFAULT_OPTIONS.merge(options)
        raise ArgumentError unless options[:versions].is_a? Array

        base_path       = File.join(options[:root_dir], options[:input_dir])
        output_path     = determine_output_path(options[:root_dir], options[:output_dir])
        input_file_path = File.join(base_path, options[:base_image])
        copy_composed   = options[:copy]

        process_icon_versions(options[:versions], options[:custom_versions]) do |version|
          build_mode, output_file_path  = copy_or_generate_file(
                                            input_file_path,
                                            base_path,
                                            output_path,
                                            copy_composed,
                                            version
                                          )

          if block_given?
            yield output_file_path, build_mode
          end
        end
      end

      private

      def copy_or_generate_file(input_file_path, base_path, output_path, copy_composed, version)
        sizes               = version[:dimensions] || version[:sizes]
        composed_file_path  = File.join(base_path, version[:filename])
        output_file_path    = File.join(output_path, version[:filename])
        output_format       = version[:format]

        # check for self composed icon file
        if copy_composed && File.exist?(composed_file_path)
          copy_image(composed_file_path, output_file_path)
          return :copied, output_file_path
        else
          generate_file(output_format, sizes, input_file_path, output_file_path)
          return :generated, output_file_path
        end
      end

      def generate_file(format, sizes, input_file_path, output_file_path)
        case format.to_sym
        when :png
          image = MiniMagick::Image.open(input_file_path)
          image.define "png:include-chunk=none,trns,gama"
          image.colorspace COLORSPACE_IN
          image.resize sizes
          image.format "png"
          image.strip
          image.colorspace COLORSPACE_OUT
          image.write output_file_path
        when :ico
          ico_cmd = "convert \"#{input_file_path}\" -colorspace #{COLORSPACE_IN} "
          escapes = "\\" unless on_windows?
          sizes.split(',').sort_by{|s| s.split('x')[0].to_i}.each do |size|
            ico_cmd << "#{escapes}( -clone 0 -resize #{size} #{escapes}) "
          end
          ico_cmd << "-delete 0 -colorspace #{COLORSPACE_OUT} \"#{output_file_path}\""
          puts `#{ico_cmd}`
        end
      end

      def copy_image(composed_file_path, output_file_path)
        FileUtils.cp(composed_file_path, output_file_path)
      end

      def determine_output_path(root_dir, output_dir)
        if Pathname.new(output_dir).absolute?
          output_dir
        else
          File.join(root_dir, output_dir)
        end
      end

      def process_icon_versions(versions, custom_versions, &block)
        icon_versions_available = ICON_VERSION_DEFINITIONS.merge(custom_versions)

        (versions + custom_versions.keys).uniq.each do |version_label|
          yield icon_versions_available[version_label]
        end
      end

      def print_image_magick_warning
        puts "FaviconMaker: WARNING! Your installed ImageMagick version #{IM_VERSION} is not up-to-date and might produce suboptimal output!"
      end

      def on_windows?
        (RbConfig::CONFIG['host_os'].match /mswin|mingw|cygwin/)
      end

    end
  end
end
