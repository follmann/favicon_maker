FaviconMaker
============

FaviconMaker aims to ease the tedious process of creating multiple versions of your favicon in different sizes and formats.

The basic idea is to have one image file as source for all the different sizes and or formats (png/ico). If the input folder contains a precomposed file like a visually improved version of the 16x16 favicon.ico this file version will not be generated but the file optionally be copied to the output folder. The remaining versions will still be sourced from the input image defined.

## Install
### Standalone
    gem install favicon_maker

### Using Bundler (recommended)
    ...
    gem "favicon_maker"
    ...

## Integration
### Middleman
In order to integrate the FaviconMaker effortless into your [Middleman](https://github.com/tdreyno/middleman) project use the following gem: [middleman-favicon-maker](https://github.com/follmann/middleman-favicon-maker)
### Rails
Soon to come... Have a look on the basic usage for now.

## Basic Usage
### Simple
    require "rubygems"
    require "favicon_maker"
    
    FaviconMaker::Generator.create_versions

Uses the following defaults:

    options = {
      :versions => [:apple_114, :apple_72, :apple_57, :apple_pre, :apple, :fav_png, :fav_ico],
      :custom_versions => {},
      :root_dir => File.dirname(__FILE__),
      :input_dir => "favicons",
      :base_image => "favicon_base.png",
      :output_dir => "favicons_output",
      :copy => false
    }

### Advanced 
(attempted Rails integration, could be used in a Rake task or Capistrano recipe)

    options = {
      :versions => [:apple_114, :apple_57, :apple, :fav_png, :fav_ico],
      :custom_versions => {:apple_extreme_retina => {:filename => "apple-touch-icon-228x228-precomposed.png", :dimensions => "228x228", :format => "png"}}
      :root_dir => Rails.root,
      :input_dir => File.join(Rails.root, "app", "assets", "public"),
      :base_image => "favico.png",
      :output_dir => "public",
      :copy => true
    }
    FaviconMaker::Generator.create_versions(options) do |filepath|
      Rails.logger.info "Created favicon: #{filepath}"
    end
## Base Image Guideline
Choose the version with the biggest dimension as your base image. Currently the size 114x114 for newer iOS devices marks the upper limit. So just create a PNG with 24 or 32 Bit color depth and 114x114 document size. Downscaling of images always works better than upscaling.

## Copyright

&copy; 2011 Andreas Follmann. See LICENSE for details.