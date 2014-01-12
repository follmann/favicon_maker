
FaviconMaker [![Build Status](https://secure.travis-ci.org/follmann/favicon_maker.png)](http://travis-ci.org/follmann/favicon_maker)
============

Tired of creating a gazillion different favicons to satisfy all kinds of devices and resolutions in different file formats?

I know I was, so I created FaviconMaker to ease the tedious process of creating multiple versions of your favicon. The basic idea is to have a template image file as source for all the different sizes and or formats (png/ico). From v1.x on it is possible to use multiple template files.

## Installation
Using Bundler

``` shell
gem "favicon_maker"
```
## Using the DSL 
### Definition
* ```setup``` takes the directory config
* ```from```  defines the template to be used
* ```icon```  needs at least a filename. Usually the size and the file format are encoded in that name e.g. ```apple-touch-icon-152x152-precomposed.png```, if that is the case FaviconMaker tries to extract that information. It takes an options hash as the second argument where ```size``` e.g. "16x16" and ```format``` e.g. :ico can be specified. Only .ico and .png are supported. The options passed take precedence over information extracted from the filename.
* ```each_icon``` is called for every generated file with the fully qualified output filepath

### Complete example:
``` ruby
FaviconMaker.generate do
 
  setup do
    template_dir  "/home/app/favicon-templates"
    output_dir    "/home/app/public"
  end

  from "favicon_base_hires.png" do
    icon "apple-touch-icon-152x152-precomposed.png"
    icon "apple-touch-icon-144x144-precomposed.png"
    icon "apple-touch-icon-120x120-precomposed.png"
    icon "apple-touch-icon-114x114-precomposed.png"
    icon "favicon-196x196.png"
    icon "favicon-160x160.png"
    icon "favicon-96x96.png"
    icon "mstile-144x144", format: "png"
  end

  from "favicon_base.png" do
    icon "apple-touch-icon-76x76-precomposed.png"
    icon "apple-touch-icon-72x72-precomposed.png"
    icon "apple-touch-icon-60x60-precomposed.png"
    icon "apple-touch-icon-57x57-precomposed.png"
    icon "apple-touch-icon-precomposed.png", size: "57x57"
    icon "apple-touch-icon.png", size: "57x57"
    icon "favicon-32x32.png"
    icon "favicon-16x16.png"
    icon "favicon.png", size: "16x16"
    icon "favicon.ico", size: "64x64,32x32,24x24,16x16"
  end

  each_icon do |filepath|
    puts filepath # verbose example
  end
end
```

## Changes from v0.3 to v1.0
* Almost entire rewrite
* DSL to configure the output
* No internal configuration and format definitions anymore
* Support for multiple template files

## Integration
### Middleman
In order to integrate the FaviconMaker effortless into your [Middleman](https://github.com/tdreyno/middleman) project use the following gem: [middleman-favicon-maker](https://github.com/follmann/middleman-favicon-maker) with version v3.5 or higher

## Template Image Guideline
Choose the version with the biggest dimension as your base image. Currently the size 152x152 for newer iOS devices marks the upper limit. So just create a PNG with 24 or 32 Bit color depth and 152x152 document size. Downscaling of images always works better than upscaling. Use more than one template file to improve lower resolutions.

## DEPRECATED - FaviconMaker v0.x
### Integration
#### Middleman
In order to integrate the FaviconMaker effortless into your [Middleman](https://github.com/tdreyno/middleman) project use the following gem: [middleman-favicon-maker](https://github.com/follmann/middleman-favicon-maker) till version v3.4

#### Capistrano
1. Edit your Capfile and add the following line
``` ruby
require "favicon_maker"
```
2. Add the following snippet to your deploy.rb

``` ruby
namespace :favicon do
  task :create_versions do
    options = {
      :root_dir => release_path,
      :input_dir => File.join("app", "assets", "public"),
      :output_dir => "public"
    }
    FaviconMaker::Generator.create_versions(options) do |filepath|
      puts "Created favicon: #{filepath}"
    end
  end
end

after "deploy:update_code", "favicon:create_versions"
```

**Note: This snippet is untested but should work**

### v0.x Usage
#### Simple

``` ruby
require "rubygems"
require "favicon_maker"

FaviconMaker::Generator.create_versions
```
Uses the following defaults:
``` ruby
options = {
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
  :custom_versions => {},
  :root_dir => File.dirname(__FILE__),
  :input_dir => "favicons",
  :base_image => "favicon_base.png",
  :output_dir => "favicons_output",
  :copy => false
}
```
#### Advanced
(untested attempted Rails integration, using all available options. Could be used in a Rake task or Capistrano recipe)
``` ruby
options = {
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
      :filename => "apple-touch-icon-228x228-precomposed.png",
      :dimensions => "228x228",
      :format => "png"
    }
  },
  :root_dir => Rails.root,
  :input_dir => File.join("app", "assets", "public"),
  :base_image => "favicon.png",
  :output_dir => "public",
  :copy => true
}

FaviconMaker::Generator.create_versions(options) do |filepath|
  puts "Created favicon: #{filepath}"
end
```
## Copyright

&copy; 2011-2014 Andreas Follmann. See LICENSE for details.

