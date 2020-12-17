# frozen_string_literal: true

git_source(:gitlab) {|repo_name| 'http://gitlab.swiftcore.org/millrgroup/#{repo_name}' }

source "https://rubygems.org"

gem 'IOWA'

gem "jekyll", "~> 3.8.5"

# Theme
#gem "minima", "~> 2.0"

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
  gem 'jekyll-sitemap'
  gem 'jekyll-seo-tag'
  gem 'jekyll-include-with-frontmatter', '~> 0.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0" if Gem.win_platform?

gem "kramdown"
gem "mime-types"
#gem "mail"
#gem "analogger"

group :test do
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
end

