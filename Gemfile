# http://mrkn.hatenablog.com/entry/2013/10/29/120436
if ENV['BUNDLE_SOURCE'].nil? || ENV['BUNDLE_SOURCE'].empty?
  source 'https://rubygems.org'
else
  source ENV['BUNDLE_SOURCE']
end

git_source :github do |repo_name|
  unless repo_name.include?('/')
    repo_name = "#{repo_name}/#{repo_name}"
  end
  "https://github.com/#{repo_name}"
end

edge = Pathname.new(__FILE__).extname == '.edge'

if edge
  gem 'rails', github: 'rails'
  gem 'arel', github: 'rails/arel'
  gem 'sprockets-rails',  github: 'rails/sprockets-rails'
  gem 'sass-rails', github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'
else
  gem 'rails', '4.2.0.beta4'
  gem 'sprockets-rails', '3.0.0.beta1'
  gem 'sass-rails', '~> 5.0.0.beta1'
  gem 'coffee-rails', '~> 4.1.0'
end

gem 'uglifier', '>= 1.3.0'
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

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'pg'
  gem 'unicorn'
end

group :development do
  gem 'launchy' # For Capybara's save_and_open_page
  gem 'capistrano', '>= 3.2', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', '>= 1.1.2', require: false
  gem 'rubocop', require: false
end

group :test do
  if edge
    gem 'rspec-rails', github: 'rspec/rspec-rails'
    gem 'rspec', github: 'rspec/rspec'
    gem 'rspec-core', github: 'rspec/rspec-core'
    gem 'rspec-expectations', github: 'rspec/rspec-expectations'
    gem 'rspec-mocks', github: 'rspec/rspec-mocks'
    gem 'rspec-support', github: 'rspec/rspec-support'
  else
    gem 'rspec-rails', '>= 3.0.0'
    gem 'rspec', '>= 3.0.0'
  end
  gem 'fuubar', '>= 2.0.0.rc1'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails'
  gem 'capybara', '>= 2.3.0', require: 'capybara/rspec'
  gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'database_rewinder'
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
