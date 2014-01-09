require 'spec_helper'

describe FaviconMaker, '#create_versions' do

  before(:all) do
    @multi_versions = []
    @uni_versions = []
    @options = {
      :versions => [
        :apple_152,
        :apple_144,
        :apple_120,
        :apple_114,
        :apple_76,
        :apple_72,
        :apple_60,
        :apple_57,
        :apple,
        :fav_196,
        :fav_160,
        :fav_96,
        :fav_32,
        :fav_16,
        :fav_png,
        :fav_ico,
        :mstile_144
      ],
      :custom_versions => {
        :apple_extreme_retina => {
          :filename => "apple-touch-icon-228x228-precomposed.png", :sizes => "228x228", :format => "png"
        }
      },
      :root_dir => File.join(Dir.pwd, "spec"),
      :input_dir => "support",
      :copy => true
    }

    @cleanup = lambda do |output_dir|
      if Dir.exists?(output_dir)
        Dir[File.join(output_dir, "*")].each do |file|
          File.delete(file)
        end
        Dir.delete(output_dir)
      end
    end
  end

  context "multi-color icon" do
    before do
      options = @options.merge({
        :base_image => "favicon base.png",
        :output_dir => "output1"
      })

      @output_dir = File.join(options[:root_dir], options[:output_dir])

      @cleanup.call(@output_dir)

      Dir.mkdir(@output_dir)

      FaviconMaker::Generator.create_versions(options) do |filepath, status|
        @multi_versions << filepath
      end
    end

    it "creates 18 different versions" do
      @multi_versions.size.should eql(18)
    end

    it "creates files for versions" do
      @multi_versions.each do |file|
        File.exists?(file).should be_true
      end
    end

    after do
      @cleanup.call(@output_dir)
    end

  end

  context "uni-color icon" do

    before do
      options = @options.merge({
        :base_image => "favicon_base_uni.png",
        :output_dir => "output2"
      })

      @output_dir = File.join(options[:root_dir], options[:output_dir])

      @cleanup.call(@output_dir)

      Dir.mkdir(@output_dir)

      FaviconMaker::Generator.create_versions(options) do |filepath, status|
        @uni_versions << filepath
      end
    end

    it "creates 18 different versions" do
      @uni_versions.size.should eql(18)
    end

    it "creates files for versions" do
      @uni_versions.each do |file|
        File.exists?(file).should be_true
      end
    end

    after do
      @cleanup.call(@output_dir)
    end

  end

end
