require "mini_magick"
require 'fileutils'

module FaviconMaker

  class Creator
    RECENT_IM_VERSION         = "6.8.0"
    COLORSPACE_MIN_IM_VERSION = "6.7.5"

    attr_accessor :template_file_path
    attr_accessor :output_path
    attr_accessor :colorspace_in
    attr_accessor :colorspace_out
    attr_accessor :finished_block

    def initialize(template_file_path, output_path, finished_block)
      @template_file_path = template_file_path
      @output_path        = output_path
      @finished_block     = finished_block

      im_version = fetch_image_magick_version

      if im_version
        print_image_magick_ancient_version_warning  if im_version < RECENT_IM_VERSION
        if im_version < COLORSPACE_MIN_IM_VERSION
          @colorspace_in   = "sRGB"
          @colorspace_out  = "RGB"
        else
          @colorspace_in   = "RGB"
          @colorspace_out  = "sRGB"
        end
      else
        print_image_magick_no_version_warning
        @colorspace_in   = "RGB"
        @colorspace_out  = "sRGB"
      end
    end

    def icon(output_filename, options={})
      format  = options[:format]  || extract_format(output_filename)
      size    = options[:size]    || extract_size(output_filename)
      output_file_path = File.join(output_path, output_filename)

      validate_input(format, size)

      generate_file(template_file_path, output_file_path, size, format)

      finished_block.call(output_file_path, template_file_path) if finished_block
    end

    private

    def validate_input(format, size)
      unless InputValidator.valid_format?(format)
        raise ArgumentError, "FaviconMaker: Unknown icon format."
      end

      format_multi_res = InputValidator.format_multi_resolution?(format)

      unless InputValidator.valid_size?(size, format_multi_res)
        raise ArgumentError, "FaviconMaker: Size definition can't be decoded."
      end
    end

    def fetch_image_magick_version
      version = (`convert --version`).scan(/ImageMagick (\d\.\d\.\d)/).flatten.first
    end

    def extract_format(output_filename)
      File.extname(output_filename).split('.').last
    end

    def extract_size(output_filename)
      matches = output_filename.match /.*-(\d+x\d+).*/
      matches[1] if matches
    end

    def generate_file(template_file_path, output_file_path, size, format)
      case format.to_sym
      when :png
        image = MiniMagick::Image.open(template_file_path)
        image.define "png:include-chunk=none,trns,gama"
        image.colorspace colorspace_in
        image.resize size
        image.combine_options do |c|
          c.background "none"
          c.gravity "center"
          c.extent size
        end unless InputValidator.size_square?(size)
        image.format "png"
        image.strip
        image.colorspace colorspace_out
        image.write output_file_path
      when :ico
        ico_cmd = "convert \"#{template_file_path}\" -quiet -colorspace #{colorspace_in} "
        escapes = "\\" unless on_windows?
        size.split(',').sort_by{|s| s.split('x')[0].to_i}.each do |s|
          ico_cmd << "#{escapes}( -clone 0 -resize #{s} #{escapes}) "
        end
        ico_cmd << "-delete 0 -colorspace #{colorspace_out} \"#{output_file_path}\""
        print `#{ico_cmd}`
      end
    end

    def print_image_magick_ancient_version_warning
      puts "FaviconMaker: WARNING! Your installed ImageMagick version #{RECENT_IM_VERSION} is not up-to-date and might produce suboptimal output!"
    end


    def print_image_magick_no_version_warning
      puts "FaviconMaker: WARNING! The version of your installed ImageMagick could not be detected!"
    end

    def on_windows?
      (RbConfig::CONFIG['host_os'].match /mswin|mingw|cygwin/)
    end

  end

end
