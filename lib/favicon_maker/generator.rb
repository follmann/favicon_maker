require 'forwardable'
require 'docile'

module FaviconMaker

  class << self
    def generate(&block)
      Docile.dsl_eval(Generator.new, &block).start
    end
  end

  class Generator
    extend ::Forwardable

    attr_accessor :config
    attr_accessor :creators
    attr_accessor :finished_block

    delegate [:template_dir, :output_dir] => :config

    def initialize
      @creators = {}
    end

    def setup(&block)
      @config = Docile.dsl_eval(MakerConfig.new, &block)
    end

    def from(template_filename, &block)
      creators[template_filename] = block
    end

    def each_icon(&block)
      @finished_block = block
    end

    def start
      creators.each do |template_filename, creator_block|
        template_file = File.join(template_dir, template_filename)
        Docile.dsl_eval(Creator.new(template_file, output_dir, finished_block), &creator_block)
      end
    end
  end
end
