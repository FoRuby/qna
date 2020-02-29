source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use redis as cache storage
gem 'redis-rails'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Authentication
gem 'devise'
gem 'doorkeeper', '5.1.0'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'omniauth-yandex'
# AWS
gem 'aws-sdk-s3'
# Serializer
gem 'active_model_serializers'
gem 'oj'
gem 'rabl'
gem 'sidekiq', '< 6'
gem 'sinatra', require: false
gem 'whenever', require: false
# Authorization
gem 'cancancan'
# Google icons
gem 'material_icons'
gem 'mini_magick'
# Nested forms
gem 'cocoon'
# Bootstrap
gem 'bootstrap'
gem 'jquery-rails'
gem 'slim-rails'
gem 'skim'
# Sphinx
gem 'mysql2'
gem 'thinking-sphinx'

gem 'faraday'
gem 'octokit'

gem 'capybara-email'
gem 'gon'
gem 'sprockets'
gem 'mini_racer'
gem 'unicorn'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'dotenv-rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'letter_opener'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  # Acceptance tests page opener
  gem 'launchy'
  gem 'webdrivers'
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers'
  gem 'rails-controller-testing'
  gem 'webmock'
  gem 'vcr'
  gem 'database_cleaner-active_record'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
