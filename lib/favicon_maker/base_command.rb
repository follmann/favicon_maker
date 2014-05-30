module BaseCommand

  def run_convert(template_file_path, output_file_path, convert_settings, options, format, &block)
    ico_cmd =   [ "convert -background none #{options}".strip ]
    ico_cmd +=  [ "\"#{template_file_path}\" #{options_to_args(convert_settings)}" ]
    ico_cmd +=  yield([]) if block_given?
    ico_cmd +=  [ " #{format}:\"#{output_file_path}\"" ]
    @command = ico_cmd.join(' ')
  end

  def options_to_args(options)
    return nil if options.nil?
    options.map { |k,v|
      if [ :xc, :null ].include?(k)
        "#{k}:#{v}"
      else
        "-#{k} #{v}".strip
      end
    }.join(' ')
  end

  def on_windows?
    (RbConfig::CONFIG['host_os'].match /mswin|mingw|cygwin/)
  end

  def to_s
    @command
  end

end
