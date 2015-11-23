require 'fileutils'

module FaviconMaker

  class Creator
    RECENT_IM_VERSION         = "6.8.0"

    attr_accessor :template_file_path
    attr_accessor :output_path
    attr_accessor :options
    attr_accessor :finished_block

    def initialize(template_file_path, output_path, options, finished_block)
      @template_file_path = template_file_path
      @output_path        = output_path
      @options            = options
      @finished_block     = finished_block
      @command_set        = []

      im_version = fetch_image_magick_version

      if im_version
        print_image_magick_ancient_version_warning(im_version) if im_version < RECENT_IM_VERSION
      else
        print_image_magick_no_version_warning
      end
    end

    def icon(output_filename, options={})
      format  = options[:format]  || extract_format(output_filename)
      size    = options[:size]    || extract_size(output_filename)
      output_file_path = File.join(output_path, output_filename)

      validate_input(format, size)

      @command_set << [ generate_command(template_file_path, output_file_path, size, format), output_file_path, template_file_path ]
    end

    def run
      @command_set.map do |cmd, output_file_path, template_file_path|
        `#{cmd}`
        finished_block.call(output_file_path, template_file_path) if finished_block
      end
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

    def generate_command(template_file_path, output_file_path, size, format)
      args = template_file_path, output_file_path, size, @options
      case format.to_sym
      when :png then PngCommand.new(*args)
      when :ico then IcoCommand.new(*args)
      end.to_s
    end

    def print_image_magick_ancient_version_warning(im_version)
      puts "FaviconMaker: WARNING! Your installed ImageMagick version #{im_version} is not up-to-date and might produce suboptimal output!"
    end


    def print_image_magick_no_version_warning
      puts "FaviconMaker: WARNING! The version of your installed ImageMagick could not be detected!"
    end

  end

end
