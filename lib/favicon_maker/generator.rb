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

    def from(template_filename, options="", &block)
      creators[template_filename] = [options, block]
    end

    def each_icon(&block)
      @finished_block = block
    end

    def start
      creators.each do |template_filename, options_and_block|
        template_file = File.join(template_dir, template_filename)
        options, creator_block = *options_and_block
        Docile.dsl_eval(Creator.new(template_file, output_dir, options, finished_block), &creator_block).run
      end
    end
  end
end
