require 'spec_helper'
describe FaviconMaker, '#create_versions' do

  before(:all) do
    @versions = []
    options = {
      :versions => [:apple_144, :apple_114, :apple_57, :apple, :fav_png, :fav_ico],
      :custom_versions => {:apple_extreme_retina => {:filename => "apple-touch-icon-228x228-precomposed.png", :dimensions => "228x228", :format => "png"}},
      :root_dir => File.join(Dir.pwd, "spec"),
      :input_dir => "support",
      :base_image => "favicon_base.png",
      :output_dir => "generated",
      :copy => true
    }

    @generated_dir = File.join(options[:root_dir], options[:output_dir])
    Dir.mkdir(@generated_dir)

    FaviconMaker::Generator.create_versions(options) do |filepath, status|
      @versions << filepath
    end
  end

  it "creates 7 different versions" do
    @versions.size.should eql(7)
  end

  it "creates 7 files" do
    @versions.each do |file|
      File.exists?(file).should be_true
    end
  end

  after(:all) do
    @versions.each do |file|
      File.delete(file)
    end
    Dir.delete(@generated_dir)
  end
end