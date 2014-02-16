source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0.beta1'

gem 'pg', group: [:production]
gem 'sqlite3', group: [:development, :test]

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'slim-rails'

gem 'faraday'
gem 'nokogiri'

gem 'acts_as_list'
gem 'redis'
gem 'fluent-logger'
gem 'msgpack', '>= 0.5.8'
gem 'active_decorator'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'redis-rails'
gem 'settingslogic'
gem 'acts-as-taggable-on', '>= 3.0.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'launchy' # For Capybara's save_and_open_page
  gem 'capistrano', '>= 3.0', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rbenv', '>= 2.0.0', require: false
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec-rails', '3.0.0.beta1'
  gem 'rspec-instafail'
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'capybara', '>= 2.2.0'  # For RSpec 3
  gem 'capybara-webkit', '>= 1.1.0'
  gem 'database_cleaner', '>= 1.2.0'
  gem 'simplecov', require: false

  gem 'webmock'
  gem 'vcr'
  gem 'fakeredis', require: 'fakeredis/rspec'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'pry-rails'
  gem 'coveralls'
end
