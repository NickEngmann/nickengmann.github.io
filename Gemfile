source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 3.9", ">= 3.9.3"

# Fixes `jekyll serve` in ruby 3
gem "webrick"

group :jekyll_plugins do
  gem "github-pages", ">= 228"
  gem "jekyll-include-cache"
  gem "jekyll-compose"
end

gem 'wdm' if Gem.win_platform?
gem "tzinfo-data" if Gem.win_platform?