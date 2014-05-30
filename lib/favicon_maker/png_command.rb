class PngCommand

  include ::BaseCommand

  def initialize(template_file_path, output_file_path, size, options)

    convert_settings = [
      [ :define,      "png:include-chunk=none,trns,gama"  ],
      [ :format,      "png"                               ],
      [ :resize,      size                                ],
      [ :gravity,     "center"                            ],
      [ :background,  "none"                              ],
      [ :extent,      size                                ],
    ]

    run_convert(template_file_path, output_file_path, convert_settings, options, :png)

  end
end
