source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# Flexible authentication solution for Rails with Warden.
gem 'devise'
# Oauth2 strategy for Google
gem 'omniauth-google-oauth2'
# Add JQuery to Rails
gem 'jquery-rails'
# Enable AWS S3
gem "aws-sdk-s3", require: false
# Add Gravatars to your Rails
gem 'gravtastic'
# Simple Rails app configuration
gem 'figaro'
# Convert Markdown to HTML
gem 'redcarpet'
# Automatically generate links in HTML
gem "rails_autolink", "~> 1.1"
# Basic Stats Gem
gem 'descriptive_statistics', '~> 2.4.0', :require => 'descriptive_statistics/safe'
# Pretend Data
gem 'faker'
# HAML
gem 'hamlit'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Rubocop
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  # Command line tool to easily handle events on file system modifications.
  gem 'guard'
  # A Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem 'guard-rubocop'
  gem 'guard-minitest'
  gem 'guard-bundler'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'pry', '~> 0.12.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Extras

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
