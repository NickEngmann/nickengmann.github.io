# tests/spec_helper.rb
require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'
  gem 'jekyll', '~> 3.9.3'
  gem 'rspec', '~> 3.12'
  gem 'html-proofer', '~> 4.5'
end

require 'jekyll'
require 'rspec'
require 'tmpdir'
require 'fileutils'

# Helper to create a minimal Jekyll site in a temp dir
def setup_jekyll_site(config_overrides = {})
  tmpdir = Dir.mktmpdir
  site_dir = Pathname.new(tmpdir)

  # Create basic structure
  site_dir.join('_config.yml').write <<~YAML
    baseurl: ""
    url: "http://localhost"
    title: Test Site
    excerpt_separator: ""
    plugins:
      - jekyll-feed
  YML

  site_dir.join('_posts').mkdir
  site_dir.join('_posts/2024-01-01-hello-world.md').write <<~MD
    ---
    layout: post
    title: "Hello World"
    ---
    Welcome to my site!
  MD

  site_dir.join('_layouts').mkdir
  site_dir.join('_layouts/post.html').write <<~LIQUID
    <!DOCTYPE html>
    <html>
      <body>
        <h1>{{ page.title }}</h1>
        {{ content }}
      </body>
    </html>
  LIQUID

  site_dir.join('_includes').mkdir
  site_dir.join('_includes/header.html').write <<~HTML
    <header><h2>{{ site.title }}</h2></header>
  HTML

  # Apply overrides
  config = Jekyll.configuration(config_overrides.merge('source' => site_dir.to_s))
  site = Jekyll::Site.new(config)

  [site, tmpdir]
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end