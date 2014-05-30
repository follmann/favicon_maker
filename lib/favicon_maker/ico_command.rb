class IcoCommand

  include ::BaseCommand

  def initialize(template_file_path, output_file_path, size, options)

    convert_settings = [
      [ :quiet,       nil      ],
    ]

    center_settings = [
      [ :gravity,     "center" ],
      [ :background,  "none"   ],
    ]

    run_convert(template_file_path, output_file_path, convert_settings, options, :ico) do |ico_cmd|
      escapes = "\\" unless on_windows?
      size.split(',').sort_by{|s| s.split('x')[0].to_i}.each do |s|
        ico_cmd += [ "#{escapes}( -clone 0 -resize #{s}  #{options_to_args(center_settings)} -extent #{s} #{escapes})" ]
      end
      ico_cmd += [ "-delete 0" ]
    end

  end
end
