source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'unicorn'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
end

group :production, :staging do
  gem 'pg'
  gem 'rails_12factor'
end

group :production do
  gem 'sentry-raven'
end

