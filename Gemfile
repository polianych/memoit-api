source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'listen', '~> 3.0.5'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring'
gem 'spring-watcher-listen', '~> 2.0.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'kaminari'
gem 'sidekiq'
gem 'httparty'
gem 'feedjira'
gem 'nokogiri'
gem 'whenever', require: false
gem 'byebug', platform: :mri, group: [:development, :test]
gem 'minitest-around', group: :test
gem 'database_cleaner', group: :test

group :production do
    # Use Puma as the app server
    gem 'puma', '~> 3.0'
end

group :development do
  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'letter_opener'
end
