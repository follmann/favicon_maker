FaviconMaker [![Build Status](https://secure.travis-ci.org/follmann/favicon_maker.png)](http://travis-ci.org/follmann/favicon_maker) [![Code Climate](https://codeclimate.com/github/follmann/favicon_maker.png)](https://codeclimate.com/github/follmann/favicon_maker)
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
* `setup` takes the directory config
* `from`  defines the template to be used
* `icon`  needs at least a filename. Usually the size and the file format are encoded in that name e.g. `apple-touch-icon-152x152-precomposed.png`, if that is the case FaviconMaker tries to extract that information. It takes an options hash as the second argument where `size` e.g. "16x16" and `format` e.g. :ico can be specified. Only .ico and .png are supported. The options passed take precedence over information extracted from the filename.
* `each_icon` is called for every generated file with the fully qualified output filepath

### Complete example
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

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## FaviconMaker v0.x - DEPRECATED
[Old instructions for versions till v0.3](OLD_INSTRUCTIONS.md)

## Copyright

&copy; 2011-2014 Andreas Follmann. See LICENSE for details.

