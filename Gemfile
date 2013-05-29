source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.12'
gem 'pg', '0.12.2'
gem 'validates_timeliness', '~> 3.0'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'devise', '2.2.3'
gem 'redis', '2.2.0'
gem 'redis-rails', '~> 3.2.0'
gem 'resque'
gem 'backbone-on-rails'
gem 'redcarpet'
gem 'albino'
gem 'pygmentize'
gem 'httparty'
gem 'momentjs-rails'
gem 'chart-js-rails'

group :development, :test do
  gem 'rspec-rails', '2.11.0'
  gem 'guard-rspec', '1.2.1'
  gem 'spork', '0.9.2'
  gem 'guard-spork'
  gem 'interactive_editor'
  gem 'debugger'
  gem 'pry'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '1.1.2'
  gem 'rb-fsevent', '0.9.1', :require => false
  gem 'growl', '1.0.3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'coffee-rails-source-maps'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', '1.0.3'
  gem 'zurb-foundation', '3.2.5'
  #gem 'therubyracer', :platforms => :ruby
end

group :production do
  gem 'therubyracer', :platforms => :ruby
  gem 'passenger'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
