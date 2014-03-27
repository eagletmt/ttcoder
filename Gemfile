# http://mrkn.hatenablog.com/entry/2013/10/29/120436
if ENV['BUNDLE_SOURCE'].nil? || ENV['BUNDLE_SOURCE'].empty?
  source 'https://rubygems.org'
else
  source ENV['BUNDLE_SOURCE']
end

gem 'rails', '4.1.0.rc2'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
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
gem 'acts-as-taggable-on', '>= 3.0.0'

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'pg'
  gem 'unicorn'
end

group :development do
  gem 'launchy' # For Capybara's save_and_open_page
  gem 'capistrano', '>= 3.1', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', '>= 1.1.2', require: false
  gem 'capistrano-rbenv', '>= 2.0.0', require: false
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec-rails', '3.0.0.beta1'
  gem 'fuubar', '>= 1.3.2'
  # Let bundler find pre-released RSpec 3 depended by fuubar.
  gem 'rspec', '3.0.0.beta1'
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'capybara', '>= 2.2.0', require: 'capybara/rspec'  # For RSpec 3
  gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'database_cleaner', '>= 1.2.0'
  gem 'simplecov'

  gem 'webmock', require: 'webmock/rspec'
  gem 'vcr'
  gem 'fakeredis', require: 'fakeredis/rspec'
  gem 'timecop'
end

group :development, :test do
  gem 'sqlite3'

  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'pry-rails'
  gem 'coveralls'
end
