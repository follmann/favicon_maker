require "image_sorcery"
require 'fileutils'

module FaviconMaker

  class Creator
    RECENT_IM_VERSION         = "6.8.0"
    COLORSPACE_MIN_IM_VERSION = "6.7.5"

    attr_accessor :template_file_path
    attr_accessor :output_path
    attr_accessor :options
    attr_accessor :finished_block

    def initialize(template_file_path, output_path, options, finished_block)
      @template_file_path = template_file_path
      @output_path        = output_path
      @options            = options
      @finished_block     = finished_block

      im_version = fetch_image_magick_version

      if im_version
        print_image_magick_ancient_version_warning  if im_version < RECENT_IM_VERSION
      else
        print_image_magick_no_version_warning
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
        convert_settings = [
          [ :define,      "png:include-chunk=none,trns,gama"  ],
          [ :format,      "png"                               ],
          [ :resize,      size                                ],
          [ :gravity,     "center"                            ],
          [ :background,  "none"                              ],
          [ :extent,      size                                ],
        ]

        convert_settings += @options

        run_convert(output_file_path, format) do |ico_cmd|
          ico_cmd << "\"#{template_file_path}\" #{options_to_args(convert_settings)}"
        end
      when :ico
        convert_settings = [
          [ :quiet,       nil                                 ],
        ]

        convert_settings += @options

        center_settings = [
          [ :gravity,     "center"                            ],
          [ :background,  "none"                              ],
        ]

        run_convert(output_file_path, format) do |ico_cmd|
          ico_cmd << "\"#{template_file_path}\" #{options_to_args(convert_settings)}"
          escapes = "\\" unless on_windows?
          size.split(',').sort_by{|s| s.split('x')[0].to_i}.each do |s|
            ico_cmd << "#{escapes}( -clone 0 -resize #{s}  #{options_to_args(center_settings)} -extent #{s} #{escapes}) "
          end
          ico_cmd << "-delete 0"
        end
      end
    end

    def run_convert(output_file_path, format, &block)
      ico_cmd = "convert -background none "
      ico_cmd = yield(ico_cmd) if block_given?
      ico_cmd << " #{format}:\"#{output_file_path}\""
      print `#{ico_cmd}`
    end

    def options_to_args(options)
      return nil if options.nil?
      options.map { |k,v|
        if [ :xc, :null ].include?(k)
          "#{k}:#{v}"
        else
          "-#{k} #{v}"
        end
      }.join(' ')
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
