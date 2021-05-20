# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'cocoon'
gem 'devise', '4.7.2'
gem 'gon', '6.3.2'
gem 'google-cloud-storage'
gem 'octokit', '~> 4.0'
gem 'redis', '4.2.1'
gem 'slim-rails', '3.2.0'
gem 'twitter-bootstrap-rails'

gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-twitter', '1.4.0'

gem 'active_model_serializers', '0.10.10'
gem 'doorkeeper', '5.4.0'
gem 'oj', '3.10.15'

gem 'cancancan', '3.1.0'

gem 'sidekiq', '6.1.2'
gem 'whenever', '1.0.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  gem 'annotate', '3.1.1'
  gem 'factory_bot_rails', '6.0.0'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-email', '3.0.2'
  gem 'launchy', '2.5.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
