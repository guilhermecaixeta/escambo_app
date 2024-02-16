source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.7"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.1"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Repository for collecting Locale data for Ruby on Rails I18n as well as other interesting, Rails related I18n stuff http://rails-i18n.org
gem "rails-i18n"
# Enhances simple I18n backend in a way that it inflects translation data using pattern interpolation. https://rubydoc.info/gems/i18n-inflector/2.6.6/file/docs/USAGE
gem "i18n-inflector"
# Devise is a flexible authentication solution for Rails based on Warden. It:
gem "devise"
gem "devise-i18n"
# The most popular HTML, CSS, and JavaScript framework for developing responsive, mobile first projects on the web. http://getbootstrap.com
gem "bootstrap", ">= 5.0"
# Bootstrap for emails https://bootstrapemail.com/docs/usage
gem "bootstrap-email"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false
# Font awesome
gem "font_awesome5_rails"
# Authorize
gem "pundit"

# Application

# This library provides integration of the money gem with Rails.
# https://github.com/RubyMoney/money-rails
gem "money-rails"

#Image processing
gem 'image_processing'

source "https://rails-assets.org" do
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "tapioca", require: false
end

group :development do
  gem "pry-rails"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  #Better Errors replaces the standard Rails error page with a much better and more useful error page. It is also usable outside of Rails in any Rack app as Rack middleware.
  gem "better_errors"
  gem "binding_of_caller"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  # Faker is a port of Perl's Data::Faker library. It's a library for generating fake data such as names, addresses, and phone numbers.
  gem "faker"
  # Code
  gem "erb_lint", require: false
  gem "solargraph"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
