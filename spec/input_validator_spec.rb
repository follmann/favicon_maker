require 'spec_helper'

describe FaviconMaker::InputValidator do

  describe '.valid_size?' do

    context 'with valid size' do
      subject { "64x64" }

      it "returns true" do
        expect(FaviconMaker::InputValidator.valid_size?(subject)).to be_true
      end
    end

    context 'with valid sizes and multiple flag' do
      subject { "64x64,32x32,16x16" }

      it "returns true" do
        expect(FaviconMaker::InputValidator.valid_size?(subject, true)).to be_true
      end
    end

    context 'with invalid sizes' do
      subject { ["x64x64", "ABx64", "16x", "x64,32x32,16x16"] }

      it "returns false" do
        subject.each do |s|
          expect(FaviconMaker::InputValidator.valid_size?(s)).to be_false
        end
        subject.each do |s|
          expect(FaviconMaker::InputValidator.valid_size?(s, true)).to be_false
        end
      end
    end

  end

  describe '.valid_format?' do

    context 'with valid formats' do
      subject { ["png", "ico"] }

      it "returns true" do
        subject.each do |s|
          expect(FaviconMaker::InputValidator.valid_format?(s)).to be_true
        end
      end
    end

    context 'with invalid format' do
      subject { "jpg" }

      it "returns false" do
        expect(FaviconMaker::InputValidator.valid_format?(subject)).to be_false
      end
    end

  end

  describe '.format_multi_resolution?' do

    context 'with multi-res format' do
      subject { "ico" }

      it "returns true" do
        expect(FaviconMaker::InputValidator.format_multi_resolution?(subject)).to be_true
      end
    end

    context 'with single-res format' do
      subject { "png" }

      it "returns false" do
        expect(FaviconMaker::InputValidator.format_multi_resolution?(subject)).to be_false
      end
    end

  end

  describe '.size_square?' do

    context 'with square size' do
      subject { "64x64" }

      it "returns true" do
        expect(FaviconMaker::InputValidator.size_square?(subject)).to be_true
      end
    end

    context 'with non-square size' do
      subject { "64x32" }

      it "returns false" do
        expect(FaviconMaker::InputValidator.size_square?(subject)).to be_false
      end
    end
  end

end

