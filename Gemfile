source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'slim-rails', '3.2.0'
gem 'devise', '4.7.2'
gem "twitter-bootstrap-rails"
gem 'google-cloud-storage'
gem "cocoon"
gem "octokit", "~> 4.0"
gem 'redis', '4.2.1'
gem 'gon', '6.3.2'

gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-twitter', '1.4.0'

gem 'cancancan', '3.1.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'factory_bot_rails', '6.0.0'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-email', '3.0.2'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'rails-controller-testing', '1.0.5'
  gem 'launchy', '2.5.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
