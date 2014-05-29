require 'spec_helper'

describe FaviconMaker, '#create_versions' do

  let(:absolute_root_dir)     { File.join(Dir.pwd, "spec") }
  let(:absolute_template_dir) { File.join(absolute_root_dir, "support") }

  let(:output_path) { File.join(absolute_root_dir, relative_output_dir) }

  let(:total_count) { 19 }

  def cleanup(output_dir)
    if Dir.exists?(output_dir)
      Dir[File.join(output_dir, "*")].each do |file|
        File.delete(file)
      end
      Dir.delete(output_dir)
    end
  end

  def extract_size(filepath)
    matches = identify(filepath).match(/.*(PNG|ICO) (\d+x\d+).*/)
    if matches && matches.size == 3
      matches[2]
    else
      nil
    end
  end

  def is_image_square?(filepath)
    extract_size(filepath).split('x').uniq.size == 1
  end

  def is_file_image?(filepath)
    !identify(filepath).match(/no decode delegate/).nil?
  end

  def identify(filepath)
    `identify #{filepath}`
  end

  context "multi-color icon" do

    let(:relative_output_dir) { "output1" }

    before do
      cleanup(output_path)
      Dir.mkdir(output_path)
    end

    subject do
      files = []
      template_files = []

      FaviconMaker.generate do

        setup do
          template_dir  absolute_template_dir
          output_dir    output_path
        end

        from "favicon base.png" do
          icon "apple-touch-icon-152x152-precomposed.png"
          icon "apple-touch-icon-144x144-precomposed.png"
          icon "apple-touch-icon-120x120-precomposed.png"
          icon "apple-touch-icon-114x114-precomposed.png"
          icon "apple-touch-icon-76x76-precomposed.png"
          icon "apple-touch-icon-72x72-precomposed.png"
          icon "apple-touch-icon-60x60-precomposed.png"
          icon "apple-touch-icon-57x57-precomposed.png"
          icon "apple-touch-icon-precomposed.png",        size: "57x57"
          icon "apple-touch-icon.png",                    size: "57x57"
        end

        from "favicon_base.png" do
          icon "favicon-196x196.png"
          icon "favicon-160x160.png"
          icon "favicon-96x96.png"
          icon "favicon-32x32.png"
          icon "favicon-16x16.png"
          icon "favicon.png",                             size:  "16x16"
          icon "favicon.ico",                             size:  "64x64,32x32,24x24,16x16"
          icon "mstile-144x144",                          format: "png"
          icon "mstile-310x150",                          format: "png"
        end

        each_icon do |filepath, template_filepath|
          files << filepath
          template_files << template_filepath
        end
      end
      return files, template_files
    end

    it "creates multiple files" do
      files, template_files = subject
      expect(files.size).to eql(total_count)
      files.each do |file|
        expect(File.exists?(file)).to be_true
      end
      expect(template_files.uniq.size).to eql(2)
    end

    after do
      # cleanup(output_path)
    end

  end

  context "uni-color icon" do

    let(:relative_output_dir) { "output2" }

    before do
      cleanup(output_path)
      Dir.mkdir(output_path)
    end

    subject do
      files = []

      FaviconMaker.generate do

        setup do
          template_dir  absolute_template_dir
          output_dir    output_path
        end

        from "favicon_base_uni.png" do
          icon "apple-touch-icon-152x152-precomposed.png"
          icon "apple-touch-icon-144x144-precomposed.png"
          icon "apple-touch-icon-120x120-precomposed.png"
          icon "apple-touch-icon-114x114-precomposed.png"
          icon "apple-touch-icon-76x76-precomposed.png"
          icon "apple-touch-icon-72x72-precomposed.png"
          icon "apple-touch-icon-60x60-precomposed.png"
          icon "apple-touch-icon-57x57-precomposed.png"
          icon "apple-touch-icon-precomposed.png", size: "57x57"
          icon "apple-touch-icon.png",             size: "57x57"
          icon "favicon-196x196.png"
          icon "favicon-160x160.png"
          icon "favicon-96x96.png"
          icon "favicon-32x32.png"
          icon "favicon-16x16.png"
          icon "favicon.png",     size:  "16x16"
          icon "favicon.ico",     size:  "64x64,32x32,24x24,16x16"
          icon "mstile-144x144",  format: "png"
          icon "mstile-310x150",  format: "png"
        end

        each_icon do |filepath|
          files << filepath
        end
      end
      files
    end

    it "creates multiple files" do
      files = subject
      expect(files.size).to eql(total_count)
      files.each do |file|
        expect(File.exists?(file)).to be_true
      end
    end

    after do
      # cleanup(output_path)
    end
  end

  context "non-square icon" do

    let(:relative_output_dir) { "output3" }

    before do
      cleanup(output_path)
      Dir.mkdir(output_path)
    end

    subject do
      files = []

      FaviconMaker.generate do

        setup do
          template_dir  absolute_template_dir
          output_dir    output_path
        end

        from "favicon_base_non_square.png" do
          icon "apple-touch-icon-114x114-precomposed.png"
          icon "apple-touch-icon-precomposed.png", size: "57x57"
          icon "favicon.ico",     size:  "64x64,32x32,24x24,16x16"
          icon "mstile-144x144",  format: "png"
        end

        each_icon do |filepath|
          files << filepath
        end
      end
      files
    end

    it "creates multiple files" do
      files = subject
      expect(files.size).to eql(4)
      files.each do |file|
        expect(File.exists?(file)).to be_true
        expect(is_image_square?(file)).to be_true
      end
    end

    after do
      # cleanup(output_path)
    end
  end

  context "svg icon" do

    let(:relative_output_dir) { "output4" }

    before do
      cleanup(output_path)
      Dir.mkdir(output_path)
    end

    subject do
      files = []

      FaviconMaker.generate do

        setup do
          template_dir  absolute_template_dir
          output_dir    output_path
        end

        from "TRS_Logo_RGB_solo.svg", '-background grey' do
          icon "apple-touch-icon-152x152-precomposed.png"
          icon "apple-touch-icon-144x144-precomposed.png"
          icon "apple-touch-icon-120x120-precomposed.png"
          icon "apple-touch-icon-114x114-precomposed.png"
          icon "apple-touch-icon-76x76-precomposed.png"
          icon "apple-touch-icon-72x72-precomposed.png"
          icon "apple-touch-icon-60x60-precomposed.png"
          icon "apple-touch-icon-57x57-precomposed.png"
          icon "apple-touch-icon-precomposed.png", size: "57x57"
          icon "apple-touch-icon.png",             size: "57x57"
          icon "favicon-196x196.png"
          icon "favicon-160x160.png"
          icon "favicon-96x96.png"
          icon "favicon-32x32.png"
          icon "favicon-16x16.png"
          icon "favicon.png",     size:  "16x16"
          icon "favicon.ico",     size:  "64x64,32x32,24x24,16x16"
          icon "mstile-144x144",  format: "png"
          icon "mstile-310x150",  format: "png"
        end

        each_icon do |filepath|
          files << filepath
        end
      end
      files
    end

    it "creates multiple image files" do
      files = subject
      expect(files.size).to eql(total_count)
      files.each do |file|
        expect(File.exists?(file)).to be_true
      end
    end

    after do
      # cleanup(output_path)
    end
  end

end
