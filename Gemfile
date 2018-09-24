source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby File.read('.ruby-version').strip

gem 'rails', '~> 5.1.6'
gem 'pg', '~> 1'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'omniauth', '>= 1.3.1'
gem 'omniauth-google-oauth2', '>= 0.4.1'
gem 'devise', '~> 4.4.3'
gem 'slim-rails', '~> 3.1.3'
gem 'simple_form', '~> 3'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'jquery-rails', '~> 4.3.0'
gem 'rails-patterns', '~> 0'
gem 'slack-notifier', '2.3.1'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 4.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'dotenv-rails', '2.2.1'
  gem 'pry-rails', '~> 0.3.5'
  gem 'rspec-rails', '~> 3.7.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', '~> 0.58.2', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rack_session_access', '~> 0'
  gem 'shoulda-matchers', '~> 3.1.2'
end

group :production do
  gem 'newrelic_rpm'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
