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