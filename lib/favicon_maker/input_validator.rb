module FaviconMaker

  module InputValidator

    def self.valid_size?(size, multiple=false)
      matches = size =~ /^(\d+)/ && size.scan(/(\d+x\d+)/)
      return false if matches.nil? || matches.empty?
      return true if multiple && matches.size >= 1
      return true if matches.size == 1
      false
    end

    def self.format_multi_resolution?(format)
      format.to_s == "ico"
    end

    def self.valid_format?(format)
      ["ico", "png"].include?(format.to_s)
    end

    def self.size_square?(size)
      width, height = *size.split('x').map(&:to_i)
      width == height
    end
  end

end